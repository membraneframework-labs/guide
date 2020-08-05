# Testing

We strongly encourage contributors to test the elements they create.
We usually advise on creating two types of tests: Unit Tests and Integration Tests.
To facilitate writing tests and make the developer experience as smooth as possible, we expose a
couple of testing utilities inside `Membrane.Testing` package.

We will discuss and walk you through writing tests on a real-world example for the
[AAC decoder](https://github.com/membraneframework/membrane-element-aac) element.

## Setting up

In order to simplify things and make the test easier to maintain and modify, we propose the
following solution:

- Create a sample file for the element under test. As an example, for the AAC decoder we'll use a
  very simple AAC audio file
- Create a known output as a reference file. For example, we save raw audio frames as the reference
  output for our AAC Decoder. **Note**: This may not always be the best solution since most encoders
  produce a non-deterministic output for the same input
- Use the input file and reference file as sources of truth for your tests

## Running tests

To run all tests, execute:

```sh
mix test
```

## Unit Tests

We will create unit tests for our Native decoder.

We start with a standard test module definition

```elixir
defmodule Decoder.NativeTest do
  use ExUnit.Case
  alias Membrane.Element.AAC.Decoder.Native
```

Our test scenario will check if the native decoder is able to decode a single frame of data:

```elixir
  test "Decode 1 AAC frame" do
```

As described above, we will use input/reference files as our data sources. Those files are placed
inside `test/fixtures` directory

```elixir
    in_path = "fixtures/input-sample.aac" |> Path.expand(__DIR__)
    reference_path = "fixtures/reference-sample.raw" |> Path.expand(__DIR__)
    ...
    {:ok, file} = File.read(in_path)
```

The first step is to ensure we can create a `Native` decoder:

```elixir
    assert {:ok, decoder_ref} = Native.create()
```

Next, we will retrieve the first frame from the input file, pass it to the Native decoder and
assert that it was decoded correctly. Subsequent calls to `decode_frame` should return
`:not_enough_bits`, as all data is already parsed.

```elixir
    assert <<frame::bytes-size(256), _::binary>> = file
    assert :ok = Native.fill(frame, decoder_ref)
    assert {:ok, decoded_frame} = Native.decode_frame(frame, decoder_ref)
    assert {:error, :not_enough_bits} = Native.decode_frame(frame, decoder_ref)
```

Finally, we'll compare the decoded frame with a reference frame from the saved raw file.

```elixir
    {:ok, ref_file} = File.read(reference_path)

    assert <<ref_frame::bytes-size(4096), _::binary>> = ref_file
    ...
    assert bit_size(decoded_frame) == bit_size(ref_frame)
    assert Membrane.Payload.to_binary(decoded_frame) == ref_frame
  end
end
```

## Integration tests

For integration tests, we'll check if the whole decoding pipeline with our AAC decoder works
correctly.

Our test pipeline uses `Membrane.Testing.Pipeline` module. This means that we only need to specify
pipeline's `Membrane.Testing.Pipeline.Options` and all elements' links and callbacks are
automatically implemented for us.

```elixir
  Pipeline.start_link(%Pipeline.Options{
    elements: [
      file_src: %Membrane.Element.File.Source{location: in_path},
      decoder: Membrane.Element.AAC.Decoder,
      sink: %Membrane.Element.File.Sink{location: out_path}
    ]
  })
```

Now, onto our test case module:

```elixir
defmodule DecoderTest do
  use ExUnit.Case

  import Membrane.Testing.Assertions

  alias Membrane.Pipeline
```

First, we define a couple of helper methods.

`prepare_paths` generates file paths for our input/reference files as well as creates a temporary
output file for our testing pipeline which will automatically be cleaned up after the test is
finished:

```elixir
  def prepare_paths(filename) do
     in_path = "fixtures/input-#{filename}.aac" |> Path.expand(__DIR__)
     reference_path = "fixtures/reference-#{filename}.raw" |> Path.expand(__DIR__)
     out_path = "/tmp/output-decoding-#{filename}.raw"
     File.rm(out_path)
     on_exit(fn -> File.rm(out_path) end)
    {in_path, reference_path, out_path}
  end
```

`assert_files_equal` compares two on-disk files:

```elixir
  def assert_files_equal(file_a, file_b) do
    assert {:ok, a} = File.read(file_a)
    assert {:ok, b} = File.read(file_b)
    assert a == b
  end
```

Finally, our test case.
Notice the `Membrane.Testing.Assertions.assert_end_of_stream/4` call which waits and
validates that the `EndOfStream` message was received.

```elixir
  describe "Decoding Pipeline should" do
    test "Decode AAC file" do
      {in_path, reference_path, out_path} = prepare_paths("sample")
      assert {:ok, pid} =  Pipeline.start_link(%Pipeline.Options{
        elements: [
          file_src: %Membrane.Element.File.Source{location: in_path},
          decoder: Membrane.Element.AAC.Decoder,
          sink: %Membrane.Element.File.Sink{location: out_path}
        ]
      })

      assert Pipeline.play(pid) == :ok # Start the pipeline
      assert_end_of_stream pid, :sink
      assert_files_equal(out_path, reference_path) # Compare pipeline output with reference file
    end
  end
end
```

Once again, we are comparing the pipeline's output with our reference file to assert that
everything works correctly.

### Customizing pipeline module

`Membrane.Testing.Pipeline` allows us to provide our custom implementations of `Membrane.Pipeline`
callbacks that will be executed prior to `Membrane.Testing.Pipeline`'s implementations. Let's
create pipeline that will answer to requests with response we passed in initialization options.
To do this, we must define module which implements callbacks we want.

```elixir
defmodule Example.Pipeline do
  use Membrane.Pipeline

  @impl true
  def handle_init(options) do
    state = %{response: options.response}
    # put spec of choice into spec
    {{:ok, spec}, state}
  end

  @impl true
  def handle_other({:request, from}, state) do
    send(from, {:response, state.response})
    {:ok, state}
  end

  @impl true
  def handle_other(_message, state),
    do: {:ok, state}
end
```

In order to use callbacks defined in `Example.Pipeline` and pass custom initialization arguments,
we have to specify it in `Options`. Please take note that there is no `elements` nor `links`
options provided, because they can't be used with module override and will result in error
when `Membrane.Testing.Pipeline.start_link/2` or `Membrane.Testing.Pipeline.start/2` is called.

```elixir
Pipeline.start_link(%Pipeline.Options{
  module: Example.Pipeline,
  custom_args: %{response: "Hello there!"}
})
```

Now we can create another test case to try out new functionality.

```elixir
describe "Decoding Pipeline should" do
  ...

  test 'Answer with {:reponse, "Hello there!"} message' do
    assert {:ok, pid} =  Pipeline.start_link(%Pipeline.Options{...})
    assert Pipeline.play(pid) == :ok # Start the pipeline
    test_process_pid = self()
    send(pid, {:request, test_process_pid})
    assert_pipeline_receive(pid, {:request, test_process_pid}) # Check if pipeline got message
    assert_receive({:response, "Hello there!"}) # Check if we got return message
  end
end
```

## Using testing elements

Apart from the `Membrane.Testing.Pipeline`, which we've already seen, there are a bunch of other
testing utilities which may come in handy for different test scenarios:

- `Membrane.Testing.Source` - Can be either used as an alternative for `File.Source` allowing you
  to pass in a list of payloads that will be supplied to the pipeline or it will output data based
  on the `actions_generator`. It can be useful for generating sequential payloads or a random input.
- `Membrane.Testing.Sink` - A fake sink element that will pass all received buffers, events and
  caps to parent pipeline. Useful for asserting output buffers one by one.

We also prepared a bunch of assertions that work in conjunction with both
`Membrane.Testing.Pipeline` and said elements. They are stored in `Membrane.Testing.Assertions`,
they usually come in two flavors: `assert_*` and `refute_*` similarly to `ExUnit` assertions.

### Testing sink

`Membrane.Testing.Sink` reports caps, events and buffers it receives to its pipeline. If you are
using it within `Membrane.Testing.Pipeline` you can make assertions about what the
`Membrane.Testing.Sink` has received. For example, this is how `Membrane.Element.Tee.Parallel`
could be tested:

```elixir
alias Membrane.Testing.{Source, Pipeline, Sink}

range = 1..100
{:ok, pipeline} =
    Pipeline.start_link(%Pipeline.Options{
      elements: [
        src: %Source{output: range},
        tee: Tee,
        sink1: %Sink{},
        sink2: %Sink{},
      ],
      links: [
        link(:src)
        |> to(:tee)
        |> to(:sink1),
        link(:tee)
        |> to(:sink2)
      ]
    })

Membrane.Pipeline.play(pipeline)

# assert every message was received three times
Enum.each(range, fn payload ->
  assert_sink_buffer(pid, :sink1, %Buffer{payload: ^payload})
  assert_sink_buffer(pid, :sink2, %Buffer{payload: ^payload})
end)

# Wait for EndOfStream message on every sink
assert_end_of_stream(pid, :sink1, :input, 3000)
assert_end_of_stream(pid, :sink2, :input, 3000)
```

### Testing element's interaction with a pipeline

Another common use of these assertions is checking whether communication with a pipeline is
proceeding correctly. You can either check whether Pipeline received a message that would be
handled by `c:Membrane.Parent.handle_other/2`:

```elixir
assert_pipeline_receive(pipeline_pid, {:topic, _})
```

Such an assertion would assert that message matching pattern `{:topic, _}` will be sent to
pipeline with pid `pipeline_pid`.

If you were, for example, to implement a demuxer and you want to ensure pipeline is notified by
the demuxer asking for mapping of streams to pads, you would do it like this:

```elixir
assert_pipeline_notified(pipeline, :tested_demuxer, {:mapping, mapping})
assert mapping == expected_mapping
```

## Summary

Full source code for the above examples can be found in
[membrane-element-aac](https://github.com/membraneframework/membrane-element-aac/tree/master/test)
and [membrane-element-tee](https://github.com/membraneframework/membrane-element-tee/tree/master/test)
repositories.
