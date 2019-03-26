# Dynamic Pads

Dynamic pads, are pads that are created on demand when linking elements.

## Why do we need dynamic pads?

In some applications manually specifying pads isn't good enough.
Let's consider sound mixer. If we are talking about physical piece
it will usually have 8, 16, 24 or even in some extreme cases 768 inputs.
Writing specifications for all those pads would be a hassle, wouldn't it?

## Creating an element with dynamic pads

Creating an element with dynamic pads is not much different than
creating one with static pads. The key difference is that
we need to specify that one of the pads is dynamic, by setting pad `availability`
to `:on_request`.

```elixir
def_input_pads pad_name [
  availability: :on_request,
  # other properties
  ]
```

When handling incoming buffers pads will be suffixed with subsequent numbers.

Now, each time some element is linked to this pad, a new instance of the
pad is created and callback [`handle_pad_added`](https://hexdocs.pm/membrane_core/Membrane.Element.Base.Mixin.CommonBehaviour.html#c:handle_pad_added/3)
is invoked. Instances of a pad can be referenced as `{:dynamic, :input, number}`

## Handling events

What if Event such as End of Stream is passed through a pad of filter element?
Usually if you are using pads `:input` and `:output` the default
action is to forward an event. It means that if an event comes at :input
pad it is set via :output pad and vice versa.

There is one problem though, which of dynamic pad would be considered `:input`
and which would be considered `:output`? That's why you have to implement
`handle_event/4` yourself.