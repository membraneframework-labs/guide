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
      {:membrane_element_tee, "~> 0.1.0"},
      {:membrane_element_file, "~> 0.2.0"}
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

## Logging

Logging in Membrane can be configured via Elixir's `Config`. It allows to enable verbose mode and customize metadata, for example:

```elixir
config :membrane_core, :logger, verbose: true
```

See `Membrane.Logger` for details.

Moreover, pipelines support `t:Membrane.Pipeline.Action.log_metadata_t/0`, that enables setting logger metadata to all descendants of a pipeline, for example:

```elixir
@impl true
def handle_init(opts) do
  # ...
  {{:ok, log_metadata: [pipeline_id: opts.id]}, state}
end
```

To have the metadata displayed, remember to enable that in the logger backend, for example:

```elixir
config :logger, :console, metadata: [:pipeline_id]
```

The `log_metadata` action is also available in bins: `t:Membrane.Bin.Action.log_metadata_t/0`.
