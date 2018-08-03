# Creating the first pipeline

In this chapter, we will implement an example of using elements and grouping them into the pipeline.
Namely, we will write an application that reads `.mp3` file and using PortAudio library plays its content to the default audio device in your system.

## Add dependencies to `mix.exs`

Membrane Framework is spread across multiple repositories on GitHub.
First of all, you have to add to dependencies our main repository - Membrane Core, which contains all mechanisms used for managing pipelines and elements. To do this, just add the following line to `deps` in your `mix.exs`:

```elixir
{:membrane_core, "~> 0.1"},
```

Furthermore, implementations of Membrane elements are grouped in tiny modules. Each module has its own repository. In this tutorial, we will use `Membrane.Element.File` (for reading data from a file), `Membrane.Element.FFmpeg.Swresample.Converter` (for converting audio) and `Membrane.Element.PortAudio` for writing the audio to audio device:

```elixir
{:membrane_element_file, "~> 0.1"},
{:membrane_element_portaudio, "~> 0.1"},
{:membrane_element_ffmpeg_swresample, "~> 0.1"},
{:membrane_element_mad, "~> 0.1"}
```

These dependencies rely on native libraries that have to be available in your system. You can use the following commands to install them.

### MacOS

```bash
brew install mad ffmpeg portaudio
```

### Ubuntu

```bash
sudo apt-get install libmad0-dev ffmpeg portaudio19-dev
```

### Arch / Manjaro

```bash
sudo pacman -S ffmpeg libmad portaudio
```

## Create a module for our pipeline

To define a pipeline you have to create an empty module and add `use Membrane.Pipeline` clause.

```elixir
defmodule Your.Module.Pipeline do
  use Membrane.Pipeline

  ...

```

## Add `handle_init` definition

Elements used in the pipeline and links between them should be given in `handle_init` function.
This function receives single argument - configuration/options, which are given when the pipeline is started. In our case, it will be a string containing the path to the `.mp3` file to play.

```elixir
def handle_init(path_to_mp3) do
  ...
end
```

Inside handle_init, we should define all elements and links between them. Firstly, let's create the keyword list, that contains all elements that will be used in our application. Key of the keyword list represents the name that we give to the element. Value is an element specification.

```elixir
  children = [
    file_src: %Membrane.Element.File.Source{location: path_to_mp3},
    decoder: Membrane.Element.Mad.Decoder,
    converter: %Membrane.Element.FFmpeg.SWResample.Converter{source_caps: %Membrane.Caps.Audio.Raw{sample_rate: 48_000, format: :s16le, channels: 2}},
    sink: Membrane.Element.PortAudio.Sink,
  ]
```

Notice, that there are two approaches to element declarations: as a module name or as a struct of given module. The second approach gives the possibility to pass some additional argument.

Then, we should initialize a map containing links between elements. Keys and values in this map should be a tuples {element_name, element_pad} describing links:

```elixir
  links = %{
    {:file_src, :source} => {:decoder, :sink},
    {:decoder, :source} => {:converter, :sink},
    {:converter, :source} => {:sink, :sink}
  }
```

Last but not least, we should return created terms in correct format - %Pipeline.Spec{}

```elixir
  spec = %Membrane.Pipeline.Spec{
    children: children,
    links: links
  }

  {{:ok, spec}, %{}}
```

The return value contains also an empty map. It is a new state for the pipeline, which gives a possibility to store some additional information for later use. In this case, it is unnecessary.

To sum up, the whole file can look like this:

``` elixir
defmodule Your.Module.Pipeline do
  use Membrane.Pipeline

  def handle_init(path_to_mp3) do
    children = [
      file_src: %Membrane.Element.File.Source{location: path_to_mp3},
      decoder: Membrane.Element.Mad.Decoder,
      converter: %Membrane.Element.FFmpeg.SWResample.Converter{source_caps: %Membrane.Caps.Audio.Raw{sample_rate: 48000, format: :s16le, channels: 2}},
      sink: Membrane.Element.PortAudio.Sink,
    ]

    links = %{
      {:file_src, :source} => {:decoder, :sink},
      {:decoder, :source} => {:converter, :sink},
      {:converter, :source} => {:sink, :sink}
    }

    spec = %Membrane.Pipeline.Spec{
      children: children,
      links: links
    }

    {{:ok, spec}, %{}}
  end

end
```

## Run the pipeline

The simplest way to create and run above pipeline is to type in iex console:

```elixir
alias Membrane.Pipeline
{:ok, pid} = Pipeline.start_link(Membrane.CoreTest.Pipeline, "/path/to/mp3", [])
Pipeline.play(pid)
```

The given `.mp3` file should be played on default device in your system.
