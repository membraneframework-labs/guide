# More advanced pipelines

After successfully running your first Membrane Pipeline, we can move on to more complicated stuff.
In this guide, we will show you how to provide options for pads, how to link an element with dynamic pad(s)
and how to introduce synchronization of start between elements.

## Pad options

Not only elements can have options. Some pads have options as well.
You can provide them in a keyword list within the second argument of `Membrane.ParentSpec.via_out/2`
or `Membrane.ParentSpec.via_in/2`:

```elixir
links = [
  # ...
  link(:decoder) |> via_in(:input, options: [mute: true]) |> to(:mixer),
  # ...
]
```
Available pad options are documented in every element's main module in automatically generated `Pads` section.

When an input pad works in `:pull` mode you can also configure its input buffer:

```elixir
links = [
  # ...
  link(:decoder) |> via_in(:input, buffer: [preffered_size: 42_000]) |> to(:mixer),
  # ...
]
```

Available settings are described in the `t:Membrane.Core.InputBuffer.props_t/0` docs.

Of course, buffer and pad options can be combined:

```elixir
links = [
  # ...
  link(:decoder) |> via_in(:input, options: [mute: true], buffer: [preffered_size: 42_000]) |> to(:mixer),
  # ...
]
```

## Dynamic pads

#### Dynamic Pads

A dynamic pad is a type of pad that acts as a template - each time some other pad is linked to a dynamic pad, a new instance of it is created.

Dynamic pads don't have to be linked when the element is started. Obviously,
the element has to support that, but in return, it gives new possibilities when the number
of pads can change on-the-fly.

Another use case for dynamic pads is when the number of pads is not known at the compile time.
For example, an audio mixer may have an any number of inputs.


#### Creating an element with dynamic pads

Creating an element with dynamic pads is not much different than
creating one with static pads. The key difference is that
we need to specify that one of the pads is dynamic, by setting pad `availability`
to `:on_request`.

Now, each time some element is linked to this pad, a new instance of the
pad is created and callback `c:Membrane.Element.Base.handle_pad_added/3`
is invoked. Instances of a pad can be referenced as `Pad.ref(pad_name, pad_id)`.

#### Gotchas

As usual, with great power comes great responsibility. When implementing an element with
dynamic pads you need to remember to implement `c:Membrane.Element.Base.handle_pad_added/3`
and `c:Membrane.Element.Base.handle_pad_removed/3` callbacks.
`c:Membrane.Element.Base.handle_event/4` might also need some attention as the default
implementation won't support dynamic pads. And of course, the logic of an element may become more complicated
as it has to support changing number of pads.

## Options

Both elements and their pads may define their own `options` that parametrize their work.
For example, some audio decoder may have an option named `bitrate` that represents bitrate of the output data.

The options for an element are passed when the element is created, while pad options are provided when
two elements are linked

Since each element performs particular tasks, connecting elements together is crucial. This can be done via pads

Dynamic pads ([described here](elements.html#dynamic-pads)) can be linked just like any other pad.
The main difference is that each link creates a new instance of this pad, so it can be linked multiple times.

```elixir
links = [
  # ...
  link(:decoder_a) |> to(:mixer),
  link(:decoder_b) |> to(:mixer),
  link(:decoder_c) |> to(:mixer),
  # ...
]
```

You can also explicitly specify the reference of a dynamic pad that will be used.
To create such reference, use `Membrane.Pad.ref/2`:

```elixir
links = [
  # ...
  link(:decoder_a) |> via_in(Pad.ref(:input, :a)) |> to(:mixer),
  link(:decoder_b) |> via_in(Pad.ref(:input, :b)) |> to(:mixer),
  link(:microphone) |> via_in(Pad.ref(:input, 1)) |> to(:mixer),
  # ...
]
```

Here's an example of a pipeline using an element with a dynamic output pad - `Membrane.Element.Tee.Master`:

```elixir
defmodule MultipleCopyPipeline do
  use Membrane.Pipeline
  alias Membrane.Element.{File, Tee}

  @impl true
  def handle_init(_) do
    children = [
      file_src: %File.Source{location: "/tmp/source_file"},
      tee: Tee.Master,
      file_sink1: %File.Sink{location: "/tmp/destination_file1"},
      file_sink2: %File.Sink{location: "/tmp/destination_file2"},
      file_sink3: %File.Sink{location: "/tmp/destination_file3"}
    ]

    links = [
      link(:file_src) |> to(:tee),
      link(:tee) |> via_out(:master) |> to(:file_sink1),
      link(:tee) |> via_out(:copy) |> to(:file_sink2),
      link(:tee) |> via_out(:copy) |> to(:file_sink3)
    ]

    state = %{}

    {{:ok, spec: %ParentSpec{children: children, links: links}}, state}
  end
end
```

This example requires the following dependencies:

```elixir
  defp deps do
    [
      {:membrane_element_tee, "~> 0.5.0"},
      {:membrane_file_plugin, "~> 0.6.0"}
    ]
  end
```

## Selecting a clock

Some elements (most likely sinks) may provide its clock that can be used by the elements in the pipeline to create timers generating ticks
and informing about passing time. For example a sink, sending audio to a sound card may provide a clock based on
a hardware clock on the device.

If the pipeline ignores that clock, the clocks are not aligned, i.e. time is passing slower according to
one of them, and one of the elements inside the pipeline produces data according to VM time, the tempo of data generation
will be different from the tempo of data consumption. This will eventually result in either buffer overflow or underflow
(causing, for example, audible 'cracks' in audio playback if the proper amount of audio samples is not available on time).

Clock provider is an element that exports clock that should be used as the pipeline clock - the default clock used by elements' timers.
When there is only one element providing clock, the pipeline can choose it automatically. When there are two or more such elements,
you can set it by providing an atom with element's name via `:clock_provider` field inside `Membrane.ParentSpec` struct:

```elixir
%ParentSpec{
  children: [
    # ...
    hardware_sink: # ... ,
    # ...
  ]
  # ...
  clock_provider: :hardware_sink,
  # ...
}
```

## Synchronization

Sometimes, you may need to synchronize some of the elements within a pipeline. A good example of a situation where such synchronization is needed is playing audio and video with 2 separate sinks.
To do this you can use `:stream_sync` field in `Membrane.ParentSpec` struct to specify elements that should start playing at the same moment. You can set it to `:sinks` atom synchronizing all sinks in the pipeline:

```elixir
%ParentSpec{
  # ...
  stream_sync: :sinks
  # ...
}
```

 or a list of groups (lists) of elements synchronizing all elements in each group:

```elixir
%ParentSpec{
  children: [
    # ...
    element1: # ... ,
    element2: # ... ,
    element3: # ... ,
    element4: # ... ,
    # ...
  ]
  # ...
  stream_sync: [[:element1, :element2], [:element3, :element4]]
  # ...
}
```
It is worth mentioning that to keep the stream synchronized all involved elements need to rely on the same clock.

By default, no elements are synchronized.
