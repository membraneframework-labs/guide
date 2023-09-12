## Pipeline

`Pipeline` allows you to spawn `Element`s and establish data flow between them. Pipeline can also communicate with elements or terminate them. Elements within a pipeline are often referred to as its `children` and the pipeline is their `parent`.

Connecting elements together is called `linking`. 

To create a pipeline, you need to implement the `Membrane.Pipeline` behaviour. It boils down to implementing callbacks and returning actions from them. For a simple pipeline, it's sufficient to implement the `handle_init` callback, which is called upon the pipeline startup, and return the `spec` action, which spawns and links elements. Let's see it in an example:

### Sample pipeline

```elixir
Mix.install([
  :membrane_hackney_plugin,
  :membrane_mp3_mad_plugin,
  :membrane_portaudio_plugin,
])

defmodule MyPipeline do
  use Membrane.Pipeline

  @impl true
  def handle_init(_ctx, mp3_url) do
    spec =
      child(%Membrane.Hackney.Source{
        location: mp3_url, hackney_opts: [follow_redirect: true]
      })
      |> child(Membrane.MP3.MAD.Decoder)
      |> child(Membrane.PortAudio.Sink)

    {[spec: spec], %{}}
  end
end

mp3_url = "https://raw.githubusercontent.com/membraneframework/membrane_demo/master/simple_pipeline/sample.mp3"

Membrane.Pipeline.start_link(MyPipeline, mp3_url)
```

This is an [Elixir](elixir-lang.org) snippet, that streams an mp3 via HTTP and plays it on your speaker. Here's how to run it:
- Install libmad and portaudio. Membrane uses these libs to decode the mp3 and to access your speaker, respectively. You can use these commands:
  - On Mac OS: `brew install libmad portaudio pkg-config`
  - On Debian: `apt install libmad0-dev portaudio19-dev`

- Option 1: Click the button below:

  [![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Fmembraneframework%2Fmembrane_core%2Fblob%2Freadme%2Fexample.livemd)

  It will install [Livebook](livebook.dev), an interactive notebook similar to Jupyter, and it'll open the snippet in there for you. Then just click the 'run' button in there.

- Option 2: If you don't want to use Livebook, you can [install Elixir](https://elixir-lang.org/install.html), type `iex` to run interactive shell and paste the snippet there.


### Example explained

Let's figure out step-by-step what happens in the sample pipeline.

Firstly, we install the needed dependencies:

```elixir
Mix.install([
  :membrane_hackney_plugin,
  :membrane_mp3_mad_plugin,
  :membrane_portaudio_plugin,
])
```

Instead of creating a script and using `Mix.install`, you can also [create a Mix project](https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html) and add these dependencies to `deps` in `mix.exs` file.

After installing the dependencies, we can create a module for our pipeline:

```elixir
defmodule MyPipeline do
  use Membrane.Pipeline

end
```

and implement the `handle_init` callback:

```elixir
defmodule MyPipeline do
  use Membrane.Pipeline

  @impl true
  def handle_init(_ctx, path_to_mp3) do

  end
end
```

The `handle_init` callback is executed at the pipeline startup. We use it to spawn and link elements:

```elixir
@impl true
def handle_init(_ctx, path_to_mp3) do
  spec =
    child(%Membrane.Hackney.Source{
      location: mp3_url, hackney_opts: [follow_redirect: true]
    })
    |> child(Membrane.MP3.MAD.Decoder)
    |> child(Membrane.PortAudio.Sink)

  {[spec: spec], %{}}
end
```

The spawned elements are:
- Hackney source - element based on the [Hackney HTTP library](https://github.com/benoitc/hackney), that downloads a file via HTTP chunk by chunk, and sends these chunks through its `output` pad. We pass two options to it: url where the MP3 is stored and a flag to make it follow HTTP redirects.
- MP3 decoder - element based on [libmad](https://github.com/markjeee/libmad), that accepts MP3 audio on the `input` pad and sends decoded audio through the `output` pad.
- PortAudio sink - element that accepts decoded audio on its `input` pad and uses the [PortAudio](https://github.com/PortAudio/portaudio) library to play in on speaker.

In our spec, we don't mention names of the pads, because `input` and `output` are the defaults. However, we could explicitly specify them:

```elixir
spec =
  child(%Membrane.Hackney.Source{
    location: mp3_url, hackney_opts: [follow_redirect: true]
  })
  |> via_out(:output)
  |> via_in(:input)
  |> child(Membrane.MP3.MAD.Decoder)
  |> via_out(:output)
  |> via_in(:input)
  |> child(Membrane.PortAudio.Sink)
```

Even though not necessary here, `via_in` and `via_out` are useful in more complex scenarios that we'll cover later.

The value returned from `handle_init`:

```elixir
{[spec: spec], %{}}
```

is a tuple containing the list of actions and the state.
- Actions are the way to interact with Membrane. Apart from `spec`, you can for example return `terminate: reason` that will stop the elements and terminate the pipeline. Most actions, including `spec`, can be returned from multiple callbacks, allowing, for example, to spawn elements on demand. Check the `Membrane.Pipeline` behaviour for the available callbacks and `Membrane.Pipeline.Action` for the available actions.
- State is an arbitrary data that will be passed to subsequent callbacks as the last argument. It's usually a map. As we have no use for the state in this case, we just set it to an empty map.

When we have created our pipeline module, we can call `Membrane.Pipeline.start_link` to run it:

```elixir
Membrane.Pipeline.start_link(MyPipeline, mp3_url)
```

We pass to it the pipeline module and options, which in our case is the `mp3_url`. The options are passed directly to the `handle_init` callback.

Now you know a thing or two about pipelines. Let's now have a deeper look at elements.

## Element

Elements in Membrane are the most basic entities responsible for processing multimedia.
Each instance of an element is an Elixir process, that has an internal state and communicates by message passing. You've already seen some examples of elements in the previous section.

Elements are spawned and controlled by their parent, which can be a pipeline or a bin (we'll cover bins in the subsequent section).

### Element types

The basic types of elements are the following:

* `Source` - fetches the stream from outside of the pipeline and delivers it to other elements
* `Sink` - consumes the stream from other elements
* `Filter` - receives the stream from other elements, processes it and sends it further to the subsequent elements
* `Endpoint` - a `Source` and a `Sink` combined - can both deliver and consume the data from other elements

To create an element, you need to implement the appropriate behaviour - `Membrane.Source`, `Membrane.Sink`, `Membrane.Filter` or `Membrane.Endpoint`.

### Pads

As you already learned, pads allow creating the flow of data between elements. Pads, much like contact pads on printed circuit board, are inputs and outputs of an element and are used to connect the elements with one another.
Because of that, there are two types of pads: `input` and `output`. It is worth mentioning that `Source` elements may only contain `output` pads, `Sink` elements contain only `input` pads, and `Filter` and `Endpoint` elements can have both of them.

Every pad should define a format of data that it is expecting. This format can be, for example,
raw audio with a specific sample rate or encoded audio in a given format.

In order to send data between elements, their pads need to be linked. There are a couple of rules that apply to pad linking:

* One pad of an element can only be linked with one pad from another element.
  ([dynamic pads](#dynamic-pads) can help with that limitation)
* Only links between `output` and `input` pads are allowed.
* Accepted stream formats of pads have to be compatible.

#### Defining pads

Pads can be defined using `def_input_pad` and `def_output_pad` macros. They both accept the pad name and the list of properties. The name allows to identify the pad. If an element has a single input or output pad, the convention is to name it `input` or `output`, respectively. The pad properties are listed below:

* `availability` - either `:always` - meaning the pad is static and available from the moment an element
  is spawned or `:on_request` meaning it is [dynamic](#dynamic-pads).
* `accepted_format` - a pattern for a stream format expected on the pad, for example `%Membrane.RawAudio{channels: 2}`. It serves the documentation purposes and is validated in runtime.
* `flow_control` - configures how back-pressure should be handled on the pad. You can choose from the following options:
  * `auto` - Membrane automatically manages the flow control. It works under assumption that the element does not need to block or slow down the processing rate, it just processes or consumes the stream as it flows. This option is not available for `Source` elements.
  * `manual` - You need to manually control the flow control by using the `demand` action on `input` pads and implementing the `handle_demand` callback for `output` pads.
  * `push` - it's a simple mode where an element producing data pushes it right away through the `output` pad. An `input` pad in this mode should be always ready to process that data.
* `demand_unit` - only for `flow_control` set to `manual`. Either `:bytes` or `:buffers`, specifies what unit will be used to request or receive demands.
* `options` - specification of options accepted by the pad


### Element's lifecycle

Apart from specifying pads, creating element involves implementing callbacks. They have different responsibilities are called in a specific order. As in case of pipeline, callbacks interact with the framework by returning actions.

**handle_init** is invoked once, upon the element creation.
It receives options specified by the user, which should be parsed and on their base,
the element should create and initialize its internal state. It is called synchronously (the parent waits until it returns), thus you should't perform any long tasks there.

**handle_setup** is invoked right after `handle_init`. It's intended for resource allocation or some potentially time consuming initialization. If you need to make sure that resources are properly released upon element termination, use `Membrane.ResourceGuard` or `Membrane.UtilitySupervisor`

After `handle_setup`, the following callbacks can be called at any point:
- **handle_pad_added** and **handle_pad_removed** are called when a dynamic pad is added and removed, respectively
- **handle_parent_notification** is called whenever the parent sends a notification to the element; elements can send notifications the other way with the **notify** action

**handle_playing** is called when the stream processing starts. From that point, you can return the following actions:
- **stream_format** tells subsequent element what kind of stream it should expect on the given pad
- **buffer** sends media data to the subsequent element; stream_format has to be sent before the first buffer
- **event** sends a custom struct to the subsequent or preceding element; downstream events are sent in order with buffers
- **demand** requests data from the previous element; only works for pads in `flow_control: manual` mode
- **end_of_stream** tells the subsequent element that the stream has finished, nothing can be sent through that pad afterwards

After `handle_playing`, you should expect the following callbacks to be called:

- **handle_stream_format** tells you what kind of stream you should expect on the given pad; called at least once, before `handle_start_of_stream`, may be called later when the stream format changes

- **handle_start_of_stream** is called just before the first buffer arrives arrives from the preceding element

- **handle_process** or **handle_write** is called every time a buffer arrives from the preceding element

- **handle_event** is called once an event arrives from the preceding or subsequent element

- **handle_demand** is called when the subsequent element requests data on the given pad; only works for pads in `flow_control: :manual` mode

- **handle_end_of_stream** is called when the stream has finished; it may be because the preceding element explicitly returned `end_of_stream` action, the pad is about to be unlinked or the current element is about to terminate

Finally, **handle_terminate_request** is called when the parent decides to remove the element. By default it returns the `terminate: :normal` action and the element terminates gracefully. Note that this callback is only called when the element is gracefully asked to terminate.


### Sample element

That's enough for the theory, let's write some code! We'll create a sample element and plug it into the pipeline from the previous section. Here's the element:

```elixir
defmodule VolumeKnob do
  @moduledoc """
  Membrane filter that changes the audio volume
  by the gain passed via options.
  """
  use Membrane.Filter

  alias Membrane.RawAudio

  def_input_pad :input, accepted_format: RawAudio, flow_control: :auto
  def_output_pad :output, accepted_format: RawAudio, flow_control: :auto

  def_options gain: [
    spec: float(),
    description: """
    The factor by which the volume will be changed.

    Gain smaller than 1 reduces the volume and gain
    greater than 1 increases it.
    """
  ]

  @impl true
  def handle_init(_ctx, options) do
    {[], %{gain: options.gain}}
  end
  
  @impl true
  def handle_process(:input, buffer, ctx, state) do
    stream_format = ctx.pads.input.stream_format
    sample_size = RawAudio.sample_size(stream_format)
    payload =
      for <<sample::binary-size(sample_size) <- buffer.payload>>, into: <<>> do
        value = RawAudio.sample_to_value(sample, stream_format)
        scaled_value = round(value * state.gain)
        RawAudio.value_to_sample(scaled_value, stream_format)
      end

    buffer = %Membrane.Buffer{buffer | payload: payload}
    {[buffer: {:output, buffer}], state}
  end
end
```

As the `moduledoc` says, the element can be used to adjust the audio volume. As we create a filter, we start with `use Membrane.Filter` clause. Then we define pads, one input and one output:

```elixir
alias Membrane.RawAudio

def_input_pad :input, accepted_format: RawAudio, flow_control: :auto
def_output_pad :output, accepted_format: RawAudio, flow_control: :auto
```

The element is going to receive raw audio and send the raw audio too. The raw audio (sometimes referred to as PCM - Pulse Code Modulation) is a simple digital representation of an audio wave, that we can operate on - for example, change the volume. The `Membrane.RawAudio` format is defined in the `membrane_raw_audio_format` package.

Since the element only transforms the stream as it flows, we can safely set `flow_control` to `auto` on both pads.

After defining the pads, we define options. Actually it's a single option - `gain` by which the volume will be changed.

```elixir
def_options gain: [
  spec: number(),
  description: """
  The factor by which the volume will be changed.

  Gain smaller than 1 reduces the volume and gain
  greater than 1 increases it.
  """
]
```

It's important to provide the type spec and description for each option, so that everyone knows how to use it.

Next, we implement the first callback - `handle_init`:

```elixir
@impl true
def handle_init(_ctx, options) do
  {[], %{gain: options.gain}}
end
```

The callback does not return any actions (thus the empty list), but it saves the gain passed through options in the state.

Then goes the main part of the element - the `handle_process` callback:

```elixir
@impl true
def handle_process(:input, buffer, ctx, state) do
```

The callback is called whenever a buffer arrives on a pad, and receives four arguments:
- the pad where the buffer arrived,
- the `Membrane.Buffer` structure carrying the stream data,
- `Membrane.Element.CallbackContext` providing some useful information about the element,
- the element's state that we created in `handle_init`.

Firstly, we use the callback context to get the stream format present on the pad and use a utility from `Membrane.RawAudio` to calculate the sample size:
```elixir
stream_format = ctx.pads.input.stream_format
sample_size = RawAudio.sample_size(stream_format)
```

We could have implemented the `handle_stream_format` callback and store the `sample_size` in the element's state too. When there's more work to be done once the stream format arrives, it's the preferred approach, though in a simple case like this we're good using the callback context.

The sample size is the amount of bytes that each audio sample takes. We'll use it to extract each sample from the payload:

```elixir
payload =
  for <<sample::binary-size(sample_size) <- buffer.payload>>, into: <<>> do
```

Now we can convert each sample to an integer with another utility from `Membrane.RawAudio`: `sample_to_value`. Having the integer, we can multiply it by the gain and convert back to the binary representation.

```elixir
    value = RawAudio.sample_to_value(sample, stream_format)
    scaled_value = round(value * state.gain)
    RawAudio.value_to_sample(scaled_value, stream_format)
  end
```

Finally, we can update the payload and forward the buffer to the output pad using the `buffer` action.

```elixir
  buffer = %Membrane.Buffer{buffer | payload: payload}
  {[buffer: {:output, buffer}], state}
end
```

Let's test our element by plugging it into the pipeline. Since it accepts `Membrane.RawAudio`, we should plug it after the decoder, which accepts encoded audio and outputs raw audio. Let's update the spec in the `handle_init callback`:

```elixir
spec =
  child(%Membrane.Hackney.Source{
    location: mp3_url, hackney_opts: [follow_redirect: true]
  })
  |> child(Membrane.MP3.MAD.Decoder)
  |> child(%VolumeKnob{gain: 0.2})
  |> child(Membrane.PortAudio.Sink)
```

Since we set the gain to `0.2`, the audio should play quieter than before.

## Bins

Bins, similarly to pipelines, are containers for elements. However, at the same time, they can be placed and linked within pipelines. Although bin is a separate Membrane entity, it can be perceived as a pipeline within an element. Bins can also be nested within one another, through we don't recommend too much nesting, as it may end up hard to maintain. For an example of a bin, have a look at the [RTMP source bin](https://github.com/membraneframework/membrane_rtmp_plugin/blob/master/lib/membrane_rtmp_plugin/rtmp/source/bin.ex) or [HTTP adaptive stream sink bin](https://github.com/membraneframework/membrane_http_adaptive_stream_plugin/blob/master/lib/membrane_http_adaptive_stream/sink_bin.ex).

There main use cases for a bin are:
- creating reusable element groups,
- encapsulating children management logic, for instance dynamically spawning or replacing elements as the stream changes.

### Bin's pads

Bin's pads are defined similarly to element's pads and can be linked in similar way. However, their role is limited to proxy the stream to other elements and bins inside (inputs) or outside (outputs). To achieve that, each input pad of a bin needs to be linked to both an output pad from the outside of a bin and an input pad of its child inside. Accordingly, each bin's output should be linked to output inside and input outside of the bin.

### Bin and the stream

Although the bin passes the stream through its pads, it does not access it directly, so that callbacks such as `handle_process` or `handle_event` are not found there. This is because the responsibility of the bin is to manage its children, not to process the stream. Whatever the bin needs to know about the stream, it should get via notifications from the children.

### Bin as a black box

Bins are designed to take as much responsibility for their children as possible, so that pipelines (or parent bins) don't have to depend on bins' internals. That's why notifications from the children are sent to their direct parent only. Also, messages received by a bin or pipeline can be forwarded only to its direct children.
