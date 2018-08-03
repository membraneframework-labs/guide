# Implementing new element

Implementing new element is very similar to declaring new pipeline. All you have to do is create a new module and implement some callbacks.

The first decision to make is to specify what kind of element we are going to implement: `source`, `sink` or `filter`. In this chapter, we will implement a very simple filter that counts received buffers and passes them to next element. It will build simple statistics and send them to Pipeline via `Membrane.Message` mechanism.

## Base module

To indicate choice of implementing 'filter' we have to add the following line to our module:

```elixir
use Membrane.Element.Base.Filter
```

This macro forces us to invoke some macros or implement some methods in our module:

* `def_options` macro - macro that defines known options for the element type. It automatically generates appropriate struct.
* `def_known_sink_pads` and `def_known_source_pads` - macros that define the pads of the element
* callbacks `handle_init`, `handle_demand` and `handle_process1` - callbacks that are invoked when initializing element, handling incoming demand or buffer

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

It is very common for the filter, to declare two pads that are called :source and :sink

```elixir
def_known_source_pads source: {:always, :pull, :any}
def_known_sink_pads sink: {:always, {:pull, demand_in: :bytes}, :any}
```

In above definition, atom :always means that pad of this element is always available. The other option is `:on_request` which means that pad is being created on request, for example, during the 'playing' state.

:pull declares the mode of the pad. It means that this element sends buffers to the next element only when they are demanded. Demands are received in `handle_demand` callback and they may refer to the number of bytes or buffers to send. The unit is specified by next argument - `demand_in: :bytes`.

The other option is :push mode, that means that element will send buffers whenever it wants or whenever they are available. In this case, specifying demand unit is unnecessary.

The third element in the tuple represents the capabilities of the pad. `:any` means that every type of buffers can be passed on this pad.

## `handle_init/1`

In handle_init we will initialize internal state of the element. As the first argument of callback options will be received. In our state, we will create variable for counting buffers and timer. Timer won't be initialized at this point, we will wait for 'handle_play' callback, which informs that pipeline is in the `playing` state.

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

## `handle_play/1`

Now it is a time to start timer telling that will send a :tick messages to our element when it should flush results and reset the counter. We should also remember the created timer, to be able to release it, when the pipeline will stop processing data.

```elixir
@impl true
def handle_play(state) do
  {:ok, timer} = :timer.send_interval(state.interval, :tick)
  {:ok, %{state | timer: timer}}
end
```

## `handle_demand/5`

Since both of our pads work in `pull` mode, we have to handle incoming demands. In our case this task is very simple - we have to just redirect incoming demands to the previous element.

For that purpose, we will return an action as an additional term in the output tuple: `{{:ok, action_list}, new_state}`.
Actions are generally speaking the activity that we request element to perform. The example actions are: sending buffer/event/new_caps on some pad, sending messages to the pipeline or - like in our case - sending demand on some `:sink` pad.

Actions are always the entries in the keyword list, where the key is atom indicating the action name and the value contains the parameters of the action. In this case, it is a tuple with pad name at first position and size of the demand on the second position.

```elixir
@impl true
def handle_demand(:source, size, :bytes, _context, state) do
  {{:ok, [demand: {:sink, size}]}, state}
end
```

## `handle_process1/4`

Incoming buffers are processed in this callback. We will update our counter and pass the buffer to the `:source` pad.

Overriding callback `handle_process1` means that we want to receive only one buffer at the time. But keep in mind that very often buffers are delivered to the element in groups. It is also possible to override `handle_process` callback, which by default performs that splitting job and invokes `handle_process1` callbacks.

```elixir
@impl true
def handle_process1 :sink, %Membrane.Buffer{} = buffer, _, state do
  new_state = %{counter: state.counter + 1}
  {{:ok, [buffer: {:source, buffer}]}, new_state}
end
```

## `handle_other/2`

All messages sent to the element's process, that were not recognized as an internal membrane messages (like buffers, caps, events or messages) are handled in `handle_other/2`.
We will receive our ticks here, so we will know that we should zero the counter. It is also a good place to send a message to the pipeline with the statistics.

```elixir
@impl true
def handle_other(:tick, state) do
  # create message to send
  message = %Membrane.Message{type: :statistics, payload: %{counter: state.counter}}

  # reset the timer
  new_state = %{state | counter: 0}

  {{:ok, [message: message]}, new_state}
end
```

## `handle_stop/1`

Last but not least callback is `handle_stop/1`. It is the place to stop the timer and clean up.

```elixir
@impl
def handle_stop(state) do
  {:ok, :cancel} = :timer.cancel(state.timer)
  {:ok, %{state | counter: 0,  timer: nil}}
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
    description: "Amount of the time in millisecods, telling how often statistics should be sent and zeroed"
  ]

  def_known_source_pads source: {:always, :pull, :any}
  def_known_sink_pads sink: {:always, {:pull, demand_in: :bytes}, :any}

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
  def handle_play(state) do
    {:ok, timer} = :timer.send_interval(state.interval, :tick)
    {:ok, %{state | timer: timer}}
  end

  @impl true
  def handle_demand :source, size, :buffers, _context, state do
    {{:ok, [demand: {:sink, size}]}, state}
  end

  @impl true
  def handle_process1 :sink, %Membrane.Buffer{} = buffer, _, state do
    new_state = %{counter: state.counter + 1}
    {{:ok, [buffer: {:source, buffer}]}, new_state}
  end

  @impl true
  def handle_other(:tick, state) do
    # create message to send
    message = %Membrane.Message{type: :statistics, payload: %{counter: state.counter}}

    # reset the timer
    new_state = %{state | counter: 0}

    {{:ok, [message: message]}, new_state}
  end

  @impl true
  def handle_stop(state) do
    {:ok, :cancel} = :timer.cancel(state.timer)
    {:ok, %{state | counter: 0,  timer: nil}}
  end
end
```

## Test the element

Our element is now ready! The last step is to put it in some pipeline and add callback handling messages in the pipeline. The simple example of such callback is the following:

```elixir
@impl true
def handle_message(message, _elem_name, state) do
  IO.inspect message
  {:ok, state}
end
```

You can use the pipeline from the previous chapter and put this element between the sink and the decoder.
