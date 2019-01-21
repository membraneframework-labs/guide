# Dynamic Pads

Dynamic pads, are pads that are created on demand when linking elements.

## Why do we need dynamic pads?

In some applications manually specifying pads isn't good enough.
Let's consider sound mixer. If we are talking about physical piece
it will usually have 8, 16, 24 or even in some extreme cases 768 inputs.
Writing specifications for all those pads would be a hassle, wouldn't it?

## Creating an element with dynamic pads

Creating an element with dynamic pads not much different than is not much
different than creating one with static pads. The key difference is that
we need to specify that one of the pads is dynamic, by setting `availability`
key to `:on_request`.

```elixir
def_input_pads pad_name [
  availability: :on_request, 
  # other properties
  ]
```

Now when handling incoming buffers pads will be suffixed with subsequent numbers.

## Handling events

There is one problem though? What if Event such as End of Stream is passed 
through a pad? Usually if you are using pads `:input` and `:output` default 
action is forwarding event. Forwarding means that if event comes to
`:input` pad it is sent to `:output` pad and vice versa.

There is one problem though, which of dynamic pad would be considered `:input`
and which would be considered `:output`? That's why you have to implement
`handle_event/4` yourself.

