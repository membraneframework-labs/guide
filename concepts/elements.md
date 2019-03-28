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

## Pads

Element's pads, much like contact pads on printed circuit board, are inputs and outputs of an element
and are used to connect the elements with each other.

They are covered in greater detail in [this chapter](./pads.md)

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