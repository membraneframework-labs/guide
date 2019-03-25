# Creating the first pipeline

In this chapter, we will implement an example of using elements and grouping them into the pipeline.
Namely, we will write an application that reads `.mp3` file and using PortAudio library plays its content to the default audio device in your system.

Source code for this pipeline as well as an mp3 file sample can be found in [membrane-demo repository](https://github.com/membraneframework/membrane-demo/tree/v0.3).

## Add dependencies to `mix.exs`

Membrane Framework is modular and consists of many packages available on [hex.pm](https://hex.pm/users/membrane)
To start the work, we have to add a dependency to our main package - Membrane Core, which contains all mechanisms used for creating and managing pipelines and elements. To do this, just add the following line to the `deps` in your `mix.exs`:

```elixir
{:membrane_core, "~> 0.3.0"},
```

Furthermore, there are quite a few Membrane elements providing different functionalities and supporting a variety of multimedia formats. Each element is available as a separate package.

In this tutorial, we will use `Membrane.Element.File` (for reading data from a file), `Membrane.Element.FFmpeg.Swresample.Converter` (for audio format conversion) and `Membrane.Element.PortAudio` (for writing the audio to audio device):

```elixir
{:membrane_element_file, "~> 0.2.3"},
{:membrane_element_portaudio, "~> 0.2.3"},
{:membrane_element_ffmpeg_swresample, "~> 0.2.3"},
{:membrane_element_mad, "~> 0.2.3"}
```

These dependencies rely on native libraries that have to be available in your system. You can use the following commands to install them.

### MacOS

```bash
brew install mad ffmpeg portaudio pkg-config
```

### Ubuntu

```bash
sudo apt-get install libmad0-dev libswresample-dev libavutil-dev portaudio19-dev
```

### Arch / Manjaro

```bash
sudo pacman -S ffmpeg libmad portaudio pkg-config
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
This function receives a single argument - configuration/options, which are given when the pipeline is started. In our case, it will be a string containing the path to the `.mp3` file to play.

```elixir
def handle_init(path_to_mp3) do
  ...
end
```

Inside `handle_init`, we should define all elements and links between them. Firstly, let's create the keyword list, that contains all elements that will be used in our application. Key of the keyword list represents the name that we give to the element. Value is an element specification.

```elixir
  children = [
    file_src: %Membrane.Element.File.Source{location: path_to_mp3},
    decoder: Membrane.Element.Mad.Decoder,
    converter: %Membrane.Element.FFmpeg.SWResample.Converter{output_caps: %Membrane.Caps.Audio.Raw{sample_rate: 48_000, format: :s16le, channels: 2}},
    sink: Membrane.Element.PortAudio.Sink,
  ]
```

Notice, that there are two approaches to element declarations: as a module name or as a struct of given module. The second approach gives the possibility to pass some additional argument.

Then, we should initialize a map containing links between elements. Keys and values in this map should be a tuples `{element_name, element_pad}` describing links:

```elixir
  links = %{
    {:file_src, :output} => {:decoder, :input},
    {:decoder, :output} => {:converter, :input},
    {:converter, :output} => {:sink, :input}
  }
```

Last but not least, we should return created terms in the correct format - `%Pipeline.Spec{}`

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
      converter: %Membrane.Element.FFmpeg.SWResample.Converter{output_caps: %Membrane.Caps.Audio.Raw{sample_rate: 48000, format: :s16le, channels: 2}},
      sink: Membrane.Element.PortAudio.Sink,
    ]

    links = %{
      {:file_src, :output} => {:decoder, :input},
      {:decoder, :output} => {:converter, :input},
      {:converter, :output} => {:sink, :input}
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
{:ok, pid} = Pipeline.start_link(Your.Module.Pipeline, "/path/to/mp3", [])
Pipeline.play(pid)
```

The given `.mp3` file should be played on the default device in your system. Please use `.mp3` that has no ID3 or ID3v2 tags.

The [demo available here](https://github.com/membraneframework/membrane-demo/tree/v0.3) contains an `.mp3` file without tags.
