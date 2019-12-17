# Creating the first pipeline

In this chapter, we will implement an example of using elements and grouping them into the pipeline.
Namely, we will write an application that reads `.mp3` file and using PortAudio library plays its content to the default audio device in your system.

Source code for this pipeline as well as an mp3 file sample can be found in [membrane-demo repository](https://github.com/membraneframework/membrane-demo/tree/v0.3).

## Add dependencies to `mix.exs`

Membrane Framework is modular and consists of many packages available on [hex.pm](https://hex.pm/users/membrane)
To start the work, we have to add a dependency to our main package - Membrane Core, which contains all mechanisms used for creating and managing pipelines and elements. To do this, just add the following line to the `deps` in your `mix.exs`:

```elixir
{:membrane_core, "~> 0.5.0"},
```

Furthermore, there are quite a few Membrane elements providing different functionalities and supporting a variety of multimedia formats. Each element is available as a separate package.

In this tutorial, we will use `Membrane.Element.File` (for reading data from a file), `Membrane.Element.FFmpeg.Swresample.Converter` (for audio format conversion) and `Membrane.Element.PortAudio` (for writing the audio to audio device):

```elixir
{:membrane_element_file, "~> 0.3.0"},
{:membrane_element_portaudio, "~> 0.3.1"},
{:membrane_element_ffmpeg_swresample, "~> 0.3.0"},
{:membrane_element_mad, "~> 0.3.0"}
```

These dependencies rely on native libraries that have to be available in your system. You can use [this docker image](https://hub.docker.com/r/membrane/bionic-membrane) or the following commands to install them.

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
@impl true
def handle_init(path_to_mp3) do
  ...
end
```

Inside `handle_init`, we should define all elements and links between them. Firstly, let's create the keyword list, that contains all elements that will be used in our application. Key of the keyword list represents the name that we give to the element. Value is an element specification.

```elixir
  children = %{
    file: %Membrane.Element.File.Source{location: path_to_mp3},
    decoder: Membrane.Element.Mad.Decoder,
    converter: %Membrane.Element.FFmpeg.SWResample.Converter{output_caps: %Membrane.Caps.Audio.Raw{sample_rate: 48_000, format: :s16le, channels: 2}},
    player: Membrane.Element.PortAudio.Sink,
  }
```

Notice, that there are two approaches to element declarations: as a module name or as a struct of given module. The second approach gives the possibility to pass some additional argument.

Then, we should specify links using dedicated DSL:

```elixir
  links = [
    link(:file)
    |> via_out(:output)
    |> via_in(:input)
    |> to(:decoder)
    |> via_out(:output)
    |> via_in(:input)
    |> to(:converter)
    |> via_out(:output)
    |> via_in(:input)
    |> to(:player)
  ]
```

Since used elements define pads with default names - `:output` and `:input`, we can skip `via_out` and `via_in` parts:

```elixir
  links = [
    link(:file) |> to(:decoder) |> to(:converter) |> to(:player)
  ]
```

Last but not least, we should return created terms in the correct format - `Membrane.ParentSpec` struct. Note that it's aliased by default by `Membrane.Pipeline.__using__/1`.

```elixir
  spec = %ParentSpec{
    children: children,
    links: links
  }

  {{:ok, spec: spec}, %{}}
```

The return value contains also an empty map. It is a new state for the pipeline, which gives a possibility to store some additional information for later use. In this case, it is unnecessary.

To sum up, the whole file can look like this:

``` elixir
defmodule Your.Module.Pipeline do
  use Membrane.Pipeline

  @impl true
  def handle_init(path_to_mp3) do
    children = %{
      file: %Membrane.Element.File.Source{location: path_to_mp3},
      decoder: Membrane.Element.Mad.Decoder,
      converter: %Membrane.Element.FFmpeg.SWResample.Converter{
        output_caps: %Membrane.Caps.Audio.Raw{
          sample_rate: 48_000,
          format: :s16le,
          channels: 2
        }
      },
      player: Membrane.Element.PortAudio.Sink,
    }

    links = [
      link(:file) |> to(:decoder) |> to(:converter) |> to(:player)
    ]

    spec = %ParentSpec{
      children: children,
      links: links
    }

    {{:ok, spec: spec}, %{}}
  end

end
```

## Run the pipeline

The simplest way to create and run above pipeline is to type in iex console:

```elixir
alias Your.Module.Pipeline
{:ok, pid} = Pipeline.start_link("/path/to/mp3")
Pipeline.play(pid)
```

The given `.mp3` file should be played on the default device in your system. Please use `.mp3` that has no ID3 or ID3v2 tags.

The [demo available here](https://github.com/membraneframework/membrane-demo/tree/v0.3) contains an `.mp3` file without tags.
