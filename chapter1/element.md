# Implementing new element

Implementing a new element is very similar to declaring a new pipeline. All you have to do is create a new module and implement some callbacks.

The first decision to make is to specify what kind of element we are going to implement: `source`, `sink` or `filter`. In this chapter, we will implement a very simple filter that counts received buffers and passes them to next element. It will build simple statistics and send them to Pipeline via `Membrane.Notification` mechanism.

Source code for this filter can be found in [membrane-demo repository](https://github.com/membraneframework/membrane-demo/tree/v0.2).

## Base module

To indicate the choice of implementing 'filter' we have to add the following line to our module:

```elixir
use Membrane.Element.Base.Filter
```

This macro forces us to invoke some macros or implement some methods in our module:

* `def_options` macro - macro that defines known options for the element type. It automatically generates the appropriate struct.
* `def_input_pads` and `def_output_pads` - macros that define the pads of the element
* callbacks `handle_init`, `handle_demand` and `handle_process` - callbacks that are invoked when initializing the element, handling incoming demand or buffer

## Options

Our element will have only one option - time interval, telling how often statistics should be sent and zeroed. Its definition will look like the following:

```elixir
def_options interval: [
    type: :integer,
    default: 1000,
    description: "Amount of the time in millisecods, telling how often statistics should be sent and zeroed"
  ]
```

## Pads

It is very common for the filter to declare two pads that are called :input and :output

```elixir
def_input_pads input: [availability: :always, mode: :pull, demand_unit: :bytes, caps: :any]
def_output_pads output: [availability: :always, mode: :pull, caps: :any]
```

In above definition, availability `:always` means that pad of this element is always available. The other option is `:on_request` which means that pad is being created on request, for example, during the 'playing' state.

`:pull` mode means that this element sends buffers to the next element only when they are demanded. Demands are received in `handle_demand` callback and they may refer to the number of bytes or buffers to send. The unit is specified by next argument - `demand_in: :bytes`.

The other option is :push mode, that means that element will send buffers whenever it wants or whenever they are available. In this case, specifying demand unit is unnecessary.

The next element in the keyword list represents the capabilities (caps) of the pad. `:any` means that any type of buffer can be passed on this pad. If you want to restrict the types of data allowed on this pad you can caps specifications as described in [docs](https://hexdocs.pm/membrane_core/0.2.0/Membrane.Caps.Matcher.html)

## `handle_init/1`

In `handle_init` we initialize internal state of the element. As the first argument of callback, options will be received. In our state, we will create variable for counting buffers and timer. Timer won't be initialized at this point, we will wait for 'handle_prepared_to_playing' callback, which informs that pipeline is in the `playing` state.

``` elixir
@impl true
def handle_init(%__MODULE__{interval: interval}) do
  state = %{
    interval: interval,
    counter: 0,
    timer: nil
  }
  {:ok, state}
end
```

## `handle_prepared_to_playing/1`

Now it is a time to start the timer that will send :tick messages to our element when it should flush results and reset the counter. We should also remember the created timer, to be able to release it, when the pipeline will stop processing data.

```elixir
@impl true
def handle_prepared_to_playing(_ctx, state) do
  {:ok, timer} = :timer.send_interval(state.interval, :tick)
  {:ok, %{state | timer: timer}}
end
```

## `handle_demand/5`

Since both of our pads work in `pull` mode, we have to handle incoming demands. In our case this task is very simple - we have to just redirect incoming demands to the previous element.

For that purpose, we will return an action as an additional term in the output tuple: `{{:ok, action_list}, new_state}`.
Actions are generally speaking the activity that we request the element to perform. The example actions are: sending buffer/event/new_caps on some pad, sending messages to the pipeline or - like in our case - sending demand on some `:sink` pad.

Actions are always the entries in the keyword list, where the key is an atom indicating the action name and the value contains the parameters of the action. In this case, it is a tuple with the pad name at first position and size of the demand on the second position.

```elixir
@impl true
def handle_demand(:output, size, :bytes, _context, state) do
  {{:ok, [demand: {:input, size}]}, state}
end
```

## `handle_process/4`

Incoming buffers are processed in this callback. We will update our counter and pass the buffer to the `:output` pad.

Overriding callback `handle_process` means that we want to receive only one buffer at a time. However, keep in mind that very often buffers are delivered to the element in groups. It is also possible to override `handle_process_list` callback, which by default performs that splitting job and invokes `handle_process` callbacks.

```elixir
@impl true
def handle_process(:input, %Membrane.Buffer{} = buffer, _, state) do
  new_state = %{state | counter: state.counter + 1}
  {{:ok, [buffer: {:output, buffer}]}, new_state}
end
```

## `handle_other/3`

All messages sent to the element's process that were not recognized as internal membrane messages (like buffers, caps, events or messages) are handled in `handle_other/3`.
We will receive our ticks here, so we will know that we should zero the counter. It is also a good place to send a notification to the pipeline with the statistics.

```elixir
@impl true
def handle_other(:tick, _ctx, state) do
  # create structure to send
  notification = {
    :counter,
    state.counter
  }

  # reset the timer
  new_state = %{state | counter: 0}

  {{:ok, notify: notification}, new_state}
end
```

## `handle_prepared_to_stopped/2`

Last but not least there is the `handle_prepared_to_stopped/2` callback. It is the place to stop the timer and clean up.

```elixir
@impl true
def handle_prepared_to_stopped(_ctx, state) do
  {:ok, :cancel} = :timer.cancel(state.timer)
  {:ok, %{state | counter: 0, timer: nil}}
end
```

## Summary

The complete code of our element can look like this:

```elixir
defmodule Your.Module.Element do
  use Membrane.Element.Base.Filter

  def_options interval: [
      type: :integer,
      default: 1000,
      description:
        "Amount of the time in millisecods, telling how often statistics should be sent and zeroed"
    ]

  def_input_pads input: [availability: :always, mode: :pull, demand_unit: :bytes, caps: :any]

  def_output_pads output: [availability: :always, mode: :pull, caps: :any]

  @impl true
  def handle_init(%__MODULE{interval: interval}) do
    state = %{
      interval: interval,
      counter: 0,
      timer: nil
    }

    {:ok, state}
  end

  @impl true
  def handle_prepared_to_stopped(_ctx, state) do
    {:ok, :cancel} = :timer.cancel(state.timer)
    {:ok, %{state | counter: 0, timer: nil}}
  end

  @impl true
  def handle_prepared_to_playing(_ctx, state) do
    {:ok, timer} = :timer.send_interval(state.interval, :tick)
    {:ok, %{state | timer: timer}}
  end

  @impl true
  def handle_demand(:output, size, :bytes, _context, state) do
    {{:ok, demand: {:input, size}}, state}
  end

  @impl true
  def handle_process(:input, %Membrane.Buffer{} = buffer, _, state) do
    new_state = %{state | counter: state.counter + 1}
    {{:ok, buffer: {:output, buffer}}, new_state}
  end

  @impl true
  def handle_other(:tick, _ctx, state) do
    # create term to send
    notification = {
      :counter,
      state.counter
    }

    # reset the timer
    new_state = %{state | counter: 0}

    {{:ok, notify: notification}, new_state}
  end
end
```

## Test the element

Our element is now ready! The last step is to put it in some pipeline and add callback handling notifications in the pipeline. The simple example of such callback is the following:

```elixir
@impl true
def handle_notification(notification, _elem_name, state) do
  IO.inspect(notification)
  {:ok, state}
end
```

You can use the pipeline from the previous chapter and put this element between the sink and the decoder.
