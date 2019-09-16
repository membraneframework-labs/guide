# Synchronization, clock and timers

Since version 0.4.0 Membrane Framework provides a means of synchronization between elements.
This chapter presets how to use them: how to synchronize start of streams, use a clock provided by a pipeline and create an element that is a clock provider

## Synchronization

Membrane provides a sync mechanism to make sure 2 elements will start their streams at the same time. Good news - there's no need to modify the elements
to support this feature! If the `Membrane.Pipeline.Spec` contains info about
elements to synchronize, the framework itself will ensure that they will receive
`StartOfStream` events at the same moment.

The only change introduced by this mechanism is possibility to configure latency of an element. This is achieved via new action `t:Membrane.Element.Action.latency_t/0` that can be returned from `c:Membrane.Element.Base.handle_init/1` callback:

```elixir
  @impl true
  def handle_init(options) do
    state = options |> Map.from_struct()
    {{:ok, latency: 20 |> Time.milliseconds()}, state}
  end
```

This action is useful in a scenario where, for example, audio is sent over Bluetooth that introduces noticeable delay and video is presented on screen with almost without latency. In such scenario, the video player need to be delayed to synchronize what you can see and hear. By setting latency you can
let the framework to this for you!

## Providing a clock

Some elements can provide a different source of time - like a hardware clock from sound card or elapsed time according to some library (like `libshout` consuming audio and sleeping for some time with small precision).

To become a clock provider for a pipeline your element needs to:

* use `Membrane.Element.Base.def_clock/1` to inform that this element exports clock
* send updates to the clock process (`t:Membrane.Clock.update_t/0`) containing time to the next tick

### Example

Let's consider a real-life example: [PortAudio sink element](https://github.com/membraneframework/membrane-element-portaudio).
It plays audio to the devices in your system via PortAudio library - open-source wrapper for . The native API exposed by this library is based on the callback - whenever PortAudio wants more data, it invokes a registered callback.
So, to make sure audio samples produced by other elements in a pipeline, this element should export a clock in which the current time is based on the amount of audio samples consumed by PortAudio.

First important thing is to notice is the `def_clock` macro invocation inside sink's module:

```elixir
defmodule Membrane.Element.PortAudio.Sink do
    # ...

    def_clock """
    This clock corresponds to the amount of samples consumed by PortAudio device
    and allows to synchronize with it.
    """

    # ...
end
```

With that macro present, during the initialization of the element, a clock process is spawned by the framework and its pid is available via `:clock` field in context for callbacks (other than `handle_init`).

This pid is then passed by the element to the native resource when the element enters `:playing` state

```elixir
@impl true
  def handle_prepared_to_playing(ctx, state) do

    # ...

    with {:ok, {latency_ms, native}} <-
           SyncExecutor.apply(Native, :create, [
             self(),
             ctx.clock, # <-- A clock passed here
             endpoint_id,
             ringbuffer_size,
             pa_buffer_size,
             latency
           ]) do
    # ...
```

From this point, when PortAudio consumes audio it sends the update message to this clock.

Here's the snippet from the native part of PortAudio sink. It's a callback
called by PortAudio when an output device demands more audio data. To reduce the amount of messages sent, the actual message is sent every 100th invocation of the callback.

```c
#define SAMPLES_PER_MSEC 48

static int callback(const void *_input_buffer, void *output_buffer,
                    unsigned long frames_per_buffer,
                    const PaStreamCallbackTimeInfo *_time_info,
                    PaStreamCallbackFlags _flags, void *user_data) {
  // ...

  SinkState *state = (SinkState *)user_data;

  if (++state->ticks % 100 == 0) {
    send_membrane_clock_update(env, state->clock, UNIFEX_SEND_THREADED,
                               100 * frames_per_buffer, SAMPLES_PER_MSEC);
  }

  // ...
}
```

The message format sent by `send_membrane_clock_update` is defined in `sink.spec.exs`. As you can see in the snippet below, the `:membrane_clock_update` message contains a tuple with a number of frames and number of samples per millisecond. We could divide frames by samples and get time in milliseconds, but instead we send both values (that can be interpreted as numerator and denominator) - this way the clock can ensure that division rounding error won't affect accuracy of the clock.

```elixir
sends {:membrane_clock_update :: label, {frames :: int, sample_rate_ms :: int}}
```

The clock process accepts updates in different representations of time to next tick:

* a single integer with time in milliseconds
* tuple with numerator and denominator (used above)
* rational number created by `Ratio` library (`t:Ratio.t/0`) - it can keep simplified fraction (2 integers) if needed to prevent rounding

They are described by `t:Membrane.Clock.update_t/0` type.

## Timers - using a clock

Each element can use the clock provided by a pipeline by setting up the _timer_
Timer sends ticks in intervals set at start
