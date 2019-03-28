# Pads and capabilities

To create the flow of data between elements in the application, they have to communicate with each other. For that purpose, the concept of `pads` and `capabilities` is used. `Pads` are basically inputs and outputs of the elements and because of that, there are two types of pads: `input` and `output`. It is worth mentioning that `Source` elements may only contain `output` pads, `Sinks` contain only `input` pads, and `Filters` can have both of them.

Every pad has some capabilities, which defines a type of data that it is expecting. This format can be, for example, raw audio with a specific sample rate or encoded audio in a given format.

In order to send data between elements their pads need to be linked. There are a couple of rules that apply to pad linking:

* One pad of an elment can only be linked with one pad from another element.
  ([dynamic pads](#dynamic-pads) can help with that limitation)
* Only links between `output` and `input` pads are allowed.
* Capabilities of pads have to be compatible.

## Pad properties

Each pad have some properties that can be set when defining a pad:

* Availability - either `:always` - meaning the pad is static and available from the moment an element
  is spawned or `:on_request` meaning it is [dynamic](#dynamic-pads)
* Mode:
  * `:push` - it's a simple mode where an element producing data `pushes` it right away on the output pad
    and input pad in this mode should be always ready to process that data
  * `:pull` - this mode provides a back-pressure mechanism - Source/Filter is only allowed to send data
    after receiving demand from downstream element and the responsibility of Sink/Filter is to send those
    demands
* Demand unit (only pull input pads) - specifies what unit will be used to send demands
  (either `:bytes` or `:buffers`)
* Caps - capabilities supported by the pad
* Options - specification of options accepted by pad

## Dynamic Pads

Dynamic pad is a type of pad that acts as a template - each time some other pad is linked to a dynamic pad
a new instace of it is created. That allow

### Why do we need dynamic pads?

In some applications manually specifying pads isn't good enough.
Let's consider audio mixer - it is a type of element that is likely to have numerous pads
with the same definition.
Thanks to dynamic pads there's no need to copy-paste the same definition over and over again.
Plus you won't be limited by the number of pads that have been defined.

### Creating an element with dynamic pads

Creating an element with dynamic pads is not much different than
creating one with static pads. The key difference is that
we need to specify that one of the pads is dynamic, by setting pad `availability`
to `:on_request`.

Now, each time some element is linked to this pad, a new instance of the
pad is created and callback [`handle_pad_added`](https://hexdocs.pm/membrane_core/Membrane.Element.Base.Mixin.CommonBehaviour.html#c:handle_pad_added/3)
is invoked. Instances of a pad can be referenced as `{:dynamic, :input, number}`

### Handling events

What if Event such as End of Stream is passed through a pad of filter element?
Usually if you are using pads `:input` and `:output` the default
action is to forward an event. It means that if an event comes at `:input`
pad it is set via `:output` pad and vice versa.

There is one problem though, which of dynamic pad would be considered `:input`
and which would be considered `:output`? That's why you have to implement
`handle_event/4` yourself.

## Defining a pad

Pads are defined in element's module with [def_input_pad](https://hexdocs.pm/membrane_core/Membrane.Element.Base.Mixin.SinkBehaviour.html#def_input_pad/2) and  [def_output_pad](https://hexdocs.pm/membrane_core/Membrane.Element.Base.Mixin.SinkBehaviour.html#def_output_pad/2)
