# Demands

When the link between two Membrane elements works in `:pull` mode, data between them is sent only when requested by an element consuming buffers. That "request" in our framework is called "demand".

## Demand unit

Demands might have one of the following units:

* `:bytes` — self-explanatory, refers to the number of bytes as an actual amount of data
* `:buffers` — when demanding _n_ buffers, element expects to receive _n_ `Membrane.Buffer` structs. Their size might be dependent on capabilities, the previous elements or their configuration. For example, element `Membrane.Element.File.Source` has an option named `chunk_size` that defines how big the buffers are.

Demand units handled by element should be specified as parameters of `def_input_pads`, i.e.:

```elixir
def_input_pad :input,
  mode: :pull,
  demand_in: :bytes,
  ...
```

## Handling incoming demand in a downstream element

When an element that produces buffers (Source or Filter) receives a demand, it is expected to produce data and send it through one of its output pads. Elements handle incoming demands via `handle_demand/5` callback that is supplied with the following parameters:

* `pad` - the name of the output pad on which the demand has been received
* `size` - the amount of data that is expected to be sent on given `pad`. It is important to note that the entire demand is always passed to `handle_demand` and it overrides previous value.
* `unit` - unit of the demand, self-explanatory
* `context` - `Membrane.Element.CallbackContext.Demand` structure, contains useful information like actual playback state of the element or size of the last demand (in a case where this size is equal to 0 it means that `handle_demand` has been triggered by `:redemand` action, see below)
* `state` - actual internal state of the element (like in every other callback)

Below, the very simple case of handling demand in Source element is presented. It just produces buffers on the spot in the `handle_demand` callback:

```elixir
@impl true
def handle_demand(:output, size, :buffers, _ctx, state) do
  buffers =
    1..size |> Enum.map(fn num -> %Membrane.Buffer{payload: generate_payload(num)} end)

  {{:ok, buffer: {:output, buffers}}, state}
end
```

## Demanding data from Sink or Filter

Demanding is done by returning `{:demand, {pad_name, demand_size}}` action from one of the callbacks.
For Filters the most common case is to return `:demand` from `handle_demand` callback.
It can be perceived as translating received demand from `output` pad to the other upstream element through the `input` pad:

```elixir
@impl true
def handle_demand(:output, size, _unit, %Ctx.Demand{}, state) do
  {{:ok, demand: {:input, size}}, state}
end
```

Like when receiving demand, passed value is meant to override the previous one.

If there is a need to refer to the previous value, the anonymous function can be provided, i.e.:

```elixir
@impl true
def handle_event(:output, %SomeEvent{}, _context, state) do
  {{:ok, demand: {:input, & &1+1}}, state}
end
```

Above example just increments by one more buffer (or byte, depending on the `demand_unit`) the value that was demanded previously.

## Action `:redemand`

Generally, `:redemand` action can be used in Sources or Filters. Its usage differs little in case of these two elements types, but the effect is the same: invoking `handle_demand` callback again.
When returning :redemand action from the callback, it should be supplied with the name of the appropriate output pad, i.e.:

```elixir
@impl true
def handle_other(%Membrane.Buffer{} = buffer, _ctx, state) do
  {{:ok, buffer: {:output, :buffer}, redemand: :output}, state}
end
```

### `:redemand` in Sources

In case of Sources, `:redemand` is just a helper that simplifies element's code.
The element doesn't need to generate the whole demand synchronously at `handle_demand` or store current demand size in its state, but it can just generate one buffer and return `:redemand` action.
If there is still one or more buffers to produce, returning `:redemand` will trigger the next invocation of `handle_demand` Element will produce next buffer and call `:redemand` again.
If there are no more buffers demanded, `handle_demand` won't be invoked and the loop will end.
One more advantage of the approach with `:redemand` action is that produced buffers will be sent one after another in separate messages and this could possibly improve the latency.

### `:redemand` in Filters

`:redemand` in Filters is useful in a situation where not the entire demand of output pad has been satisfied and there is a need to send a demand for additional buffers through the input pad.
A typical example of this situation is a parser that has not demanded enough bytes to parse the whole frame.
