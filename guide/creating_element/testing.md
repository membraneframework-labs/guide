# Testing

We strongly encourage contributors to test the elements they create.
We usually advise on creating two types of tests: Unit Tests and Integration Tests.
To facilitate writing tests and make the developer experience as smooth as possible, we expose a couple of testing utilities inside `Membrane.Testing` package.

We will discuss and walk you through writing tests on a real-world example for the [AAC decoder](https://github.com/membraneframework/membrane-element-aac) element.

## Setting up

In order to simplify things and make the test easier to maintain and modify, we propose the following solution:

- Create a sample file for the element under test. As an example, for the AAC decoder we'll use a very simple AAC audio file
- Create a known output as a reference file. For example, we save raw audio frames as the reference output for our AAC Decoder. **Note**: This may not always be the best solution since most encoders produce a non-deterministic output for the same input
- Use the input file and reference file as sources of truth for your tests

## Running tests

To run all tests, execute:

```sh
$ mix test
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

As described above, we will use input/reference files as our data sources. Those files are placed inside `test/fixtures` directory

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

Next, we will retrieve the first frame from the input file, pass it to the Native decoder and assert that it was decoded correctly. Subsequent calls to `decode_frame` should return `:not_enough_bits`, as all data is already parsed.

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

For integration tests, we'll check if the whole decoding pipeline with our AAC decoder works correctly.

Our test pipeline uses [`Membrane.Testing.Pipeline`](https://hexdocs.pm/membrane_core/Membrane.Testing.Pipeline.html) module. This means that we only need to specify pipeline's [`Membrane.Testing.Pipeline.Options`](https://hexdocs.pm/membrane_core/Membrane.Testing.Pipeline.Options.html) and all elements links and callbacks are automatically implemented for us.

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

`prepare_paths` generates file paths for our input/reference files as well as creates a temporary output file for our testing pipeline which will automatically be cleaned up after the test is finished:

```elixir
  def prepare_paths(filename) do
    ...
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
Notice the [`assert_end_of_stream`](https://hexdocs.pm/membrane_core/Membrane.Testing.Assertions.html#assert_end_of_stream/4) call which waits and validates that the `EndOfStream` message was received.

```elixir
  describe "Decoding Pipeline should" do
    test "Decode AAC file" do
      {in_path, reference_path, out_path} = prepare_paths("sample")
      assert {:ok, pid} =  Pipeline.start_link(%Pipeline.Options{...})

      assert Pipeline.play(pid) == :ok # Start the pipeline
      assert_end_of_stream pid, :sink
      assert_files_equal(out_path, reference_path) # Compare pipeline output with reference file
    end
  end
end
```

Once again, we are comparing the pipeline's output with our reference file to assert that everything works correctly.

## Using other testing utilities

Apart from the [`Membrane.Testing.Pipeline`](https://hexdocs.pm/membrane_core/Membrane.Testing.Pipeline.html), which we've already seen, there are a bunch of other testing utilities which may come in handy for different test scenarios:

- [`Membrane.Testing.Assertions`](https://hexdocs.pm/membrane_core/Membrane.Testing.Assertions.html) - Contains all available assertions that work alongside `Membrane.Testing.Pipeline` and `Membrane.Testing.Sink`.
- [`Membrane.Testing.Source`](https://hexdocs.pm/membrane_core/Membrane.Testing.Source.html) - Can be either used as an alternative for `File.Source` allowing you to pass in a list of payloads that will be supplied to the pipeline or it will output data based on the `actions_generator`. It can be useful for generating sequential payloads or a random input.
- [`Membrane.Testing.Sink`](https://hexdocs.pm/membrane_core/Membrane.Testing.Sink.html) - A fake sink element that will pass all received buffers, events and caps to parent pipeline. Useful for asserting output buffers one by one.

## Summary

Full source code for the above examples can be found in [membrane-element-aac](https://github.com/membraneframework/membrane-element-aac/tree/master/test) repository.
