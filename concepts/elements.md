# Elements

Elements in Membrane Framework are the most basic entities responsible for processing multimedia.
Each instance of an element is an Erlang process, that has an internal state and communicates by message passing.

Every element is created to solve one problem. The examples of elements are
audio encoder (converting raw audio to encoded format like MP3),
file source (reading data from a file and passing it to other elements) or
UDP sink (sending data from an application via UDP socket).

## Element types

There are three basic types of elements:

* `Source` - responsible for getting (or generating) data delivering it to other elements
* `Sink` - defines an endpoint for data flowing through an application.
* `Filter` - an element that receives data from other elements, processes it and sends it further to the next elements

## Playback states

Every element may be in one of three states:

* `:stopped` - element has been created
* `:prepared` - element should be ready for processing data. All necessary resources should be allocated and initialized.
* `:playing` - element is actually processing data

More detailed info can be found in [a chapter about element's lifecycle](./lifecycle.md)

## Pads and capabilities

To create the flow of data between elements in the application, they have to communicate with each other.
For that purpose, the concept of `pads` and `capabilities` is used. Element's pads, much like contact pads
on printed circuit board, are inputs and outputs of an element and are used to connect the elements with one another.
Because of that, there are two types of pads: `input` and `output`. It is worth mentioning that `Source` elements may
only contain `output` pads, `Sinks` contain only `input` pads, and `Filters` can have both of them.

Every pad has some capabilities, that define a type of data that it is expecting. This format can be, for example,
raw audio with a specific sample rate or encoded audio in a given format.

In order to send data between elements, their pads need to be linked. There are a couple of rules that apply to pad linking:

* One pad of an element can only be linked with one pad from another element.
  ([dynamic pads](#dynamic-pads) can help with that limitation)
* Only links between `output` and `input` pads are allowed.
* Capabilities of pads have to be compatible.

### Properties

Each pad has properties that can be set when defining a pad:

* Availability - either `:always` - meaning the pad is static and available from the moment an element
  is spawned or `:on_request` meaning it is [dynamic](#dynamic-pads)
* Mode:
  * `:push` - it's a simple mode where an element producing data `pushes` it right away on the output pad
    and input pad in this mode should be always ready to process that data
  * `:pull` - this mode provides a back-pressure mechanism - Source/Filter is only allowed to send data
    after receiving a demand from a downstream element and the responsibility of Sink/Filter is to send those
    demands
* Demand unit (only pull input pads) - specifies what unit will be used to send demands
  (either `:bytes` or `:buffers`)
* Caps - capabilities supported by the pad
* Options - specification of options accepted by the pad

### Dynamic Pads

A dynamic pad is a type of pad that acts as a template - each time some other pad is linked to a dynamic pad
a new instance of it is created.

#### Why do we need dynamic pads?

Dynamic pads don't have to be linked when the element is started. Obviously,
the element has to support that, but in return, it gives new possibilities when the number
of pads can change on-the-fly.

Another use case for dynamic pads is when specifying pads manually becomes cumbersome.
Let's consider an audio mixer - it is a type of element that is likely to have numerous input pads
with the same definition.
Thanks to dynamic pads there's no need to copy-paste the same definition over and over again.
Plus, you won't be limited by the number of pads that have been defined.

#### Creating an element with dynamic pads

Creating an element with dynamic pads is not much different than
creating one with static pads. The key difference is that
we need to specify that one of the pads is dynamic, by setting pad `availability`
to `:on_request`.

Now, each time some element is linked to this pad, a new instance of the
pad is created and callback [`handle_pad_added`](https://hexdocs.pm/membrane_core/Membrane.Element.Base.Mixin.CommonBehaviour.html#c:handle_pad_added/3)
is invoked. Instances of a pad can be referenced as `{:dynamic, pad_name, number}`

#### Gotchas

As usual, with great power comes great responsibility. When implementing an element with
dynamic pads you need to remember to implement `handle_pad_added` and `handle_pad_removed`
callbacks. `handle_event` might also need some attention as the default implementation won't support
dynamic pads. And of course, the logic of an element may become more complicated as it has to support
changing number of pads.

## Defining a pad

Pads are defined in an element's module with [def_input_pad](https://hexdocs.pm/membrane_core/Membrane.Element.Base.Mixin.SinkBehaviour.html#def_input_pad/2) and  [def_output_pad](https://hexdocs.pm/membrane_core/Membrane.Element.Base.Mixin.SinkBehaviour.html#def_output_pad/2)

## Options

Both elements and their pads may define their own `options` that parametrize their work.
For example, some audio decoder may have an option named `bitrate` that represents bitrate of the output data.

The options for an element are passed when the element is created, while pad options are provided when
two elements are linked

## Defining elements

Elements are Elixir modules that `use` a proper module
(either [`Membrane.Element.Base.Sink`](https://hexdocs.pm/membrane_core/Membrane.Element.Base.Sink.html),
[`Membrane.Element.Base.Filter`](https://hexdocs.pm/membrane_core/Membrane.Element.Base.Filter.html) or
[`Membrane.Element.Base.Source`](https://hexdocs.pm/membrane_core/Membrane.Element.Base.Source.html)).
They have to define options and pads using provided macros (`def_input_pad`, `def_output_pad` and `def_options`) and implement at least required callbacks.