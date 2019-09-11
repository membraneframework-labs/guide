# More advanced pipelines

After succcessfully running your first Membrane Pipeline, we can move on to more complicated stuff.
In this guide, we will show you how to provide options for pads, how to link an element with dynamic pad(s)
and how introduce synchronization of start between elements

## Pad options

Not only elements can have some options. Some pads have options as well.
You can provide them in a keyword at the end of the tuple defining link:

```elixir
links = %{
  # ...
  {:decoder, :output} => {:mixer, :input, pad: [mute: true]},
  # ...
}
```

Available pad options are documented in elements' modules in `Pads` section.

When an input pad works in `:pull` mode you can also configure the buffer:

```elixir
links = %{
  # ...
  {:decoder, :output} => {:mixer, :input, buffer: [preffered_size: 42_000]},
  # ...
}
```

Available settings are described in the `t:Membrane.Core.InputBuffer.props_t/0` docs.

Of course, buffer and pad options can be combined:

```elixir
links = %{
  # ...
  {:decoder, :output} => {:mixer, :input, pad: [mute: true], buffer: [preffered_size: 42_000]},
  # ...
}
```

## Dynamic pads

Dynamic pads ([described here](elements.html#dynamic-pads)) can be linked just like any other pad.
The main difference is that each link creates a new instance of this pad, so it can be linked multiple times.

```elixir
links = %{
  # ...
  {:decoder_a, :output} => {:mixer, :input},
  {:decoder_b, :output} => {:mixer, :input},
  {:decoder_c, :output} => {:mixer, :input},
  # ...
}
```

You can also explicitly specify the id of a dynamic pad that will be used:

```elixir
links = %{
  # ...
  {:decoder_1, :output} => {:mixer, :input, 1},
  {:decoder_2, :output} => {:mixer, :input, 2},
  {:decoder_3, :output} => {:mixer, :input, 3},
  # ...
}
```

> **Warning:**
>
> Since map is used to define links, the keys have to be unique. In case of linking
> to an element with dynamic output pad, the ids have to be provided explicitly to avoid
> multiple entries with the same key.
>
> This API limitation will be adressed in the future releases of Membrane Core, see [this GitHub issue](https://github.com/membraneframework/membrane-core/issues/159)

Here's an example of a pipeline using an element with dynamic output pad - `Membrane.Element.Tee.Master`:

```elixir
defmodule MultipleCopyPipeline do
  use Membrane.Pipeline
  alias Pipeline.Spec
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

    links = %{
      {:file_src, :output} => {:tee, :input},
      {:tee, :master} => {:file_sink1, :input},
      {:tee, :copy, 2} => {:file_sink2, :input},
      {:tee, :copy, 3} => {:file_sink3, :input}
    }

    state = %{}

    {{:ok, %Spec{children: children, links: links}}, state}
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

Some elements (most likely sinks) may provide its clock that can be used by the elements in the pipeline as a source
of ticks informing about passing time. For example a sink, sending audio to a sound card may provide a clock based on
a hardware clock on the device.

If the pipeline ignores that clock, the clocks are not aligned, i.e. time is passing slower according to
one of them, and one of the elements inside the pipeline produces data according to VM time, the tempo of data generation
will be different from the tempo of data consumption. This will eventually result in either buffer overflow
or audible 'cracks' in audio playback (if the proper amount of audio samples is not available on time).

Clock provider is an element that exports clock that should be used as the pipeline clock -
the default clock used by elements' timers. You can set it by providing an atom with element's name via `:clock_provider`
field inside `Membrane.Pipeline.Spec` struct:

```elixir
%Spec{
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
To do this you can use `:stream_sync` field in `Membrane.Pipeline.Spec` struct to specify elements that should start playing at the same moment. You can set it to `:sinks` atom or list of groups (lists) of elements.

Passing `:sinks` results in synchronizing all sinks in the pipeline,
while passing a list of groups of elements synchronizes all elements in each group.
It is worth mentioning that to keep the stream synchronized all involved elements need to rely on the same clock.

By default, no elements are synchronized.

Sample definitions:

```elixir
%Spec{
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

%Spec{
  # ...
  stream_sync: :sinks
  # ...
}
```
