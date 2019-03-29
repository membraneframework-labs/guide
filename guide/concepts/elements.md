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

### Element's lifecycle

Proper resource management is crucial when creating reliable and stable software. For this purpose, Membrane Framework
introduces few rules that unify expected behaviour of elements, so it is possible to manage them better (i.e. in pipelines).
The main tool for this is a `playback state`. Elements should react to every state change and know exactly what
should be done at the specific time of their "life".

#### Callback handle_init

Above callback is invoked only once, upon the element creation.
It receives options specified by the user, which should be parsed and on their base,
the element should create and initialize its internal state.

#### State stopped

It is the first and the last state of every element. While being in it, elements should not have any "dynamic" resources, opened files or devices.
Elements in the `stopped` state might still not be linked, thus they shouldn't return from callbacks any actions that require sending any message via pads (like caps and events).

#### Stopped -> prepared change

It is a good place to allocate all needed resources (for example native resources). Elements in pipelines are already linked when performing this callback.
If it is possible to know the capabilities of processed streams, they should be sent to other elements via `:caps` action.

#### State prepared

Elements should have already all needed resources allocated in order to process data. Although all timers should be still stopped and waiting for the stream start.
Elements are permitted to send caps and events via their pads, but sticky events will be queued in a pull buffer and processed after state change to the `playing`.
Nevertheless, other events (not sticky) will be handled with `handle_event`.

From this state, it is possible to transit to both 'stopped' and 'playing' states. Elements should be prepared for both of these changes and don't assume any of them.

#### Prepared -> playing change

If an element is based on a timer, it should be started in `handle_prepared_to_playing` callback.
Also, most Sinks should make their first demand in this callback.

#### State playing

Elements are processing data, timers are running. Sending buffers and demands is allowed now.

#### Playing -> prepared change

In callback handling this change, the element should stop all running timers.
Since this moment, elements won't process any more buffers or sticky events. All the data waiting in InputBuffers will be dropped.

#### Prepared -> stopped change

When handling this change, all allocated resources should be cleaned, devices closed. The internal state of an element should be ready for the next transition to `prepared` state.

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
pad is created and callback `c:Membrane.Element.Base.Mixin.CommonBehaviour.handle_pad_added/3`
is invoked. Instances of a pad can be referenced as `{:dynamic, pad_name, number}`

#### Gotchas

As usual, with great power comes great responsibility. When implementing an element with
dynamic pads you need to remember to implement `c:Membrane.Element.Base.Mixin.CommonBehaviour.handle_pad_added/3`
and `c:Membrane.Element.Base.Mixin.CommonBehaviour.handle_pad_removed/3` callbacks.
`c:Membrane.Element.Base.Mixin.SinkBehaviour.handle_event/4` might also need some attention as the default
implementation won't support dynamic pads. And of course, the logic of an element may become more complicated
as it has to support changing number of pads.

## Options

Both elements and their pads may define their own `options` that parametrize their work.
For example, some audio decoder may have an option named `bitrate` that represents bitrate of the output data.

The options for an element are passed when the element is created, while pad options are provided when
two elements are linked

## Defining elements

Elements are Elixir modules that `use` a proper module
(either `Membrane.Element.Base.Sink`, `Membrane.Element.Base.Filter` or `Membrane.Element.Base.Source`).
They have to define options and pads using provided macros (`Membrane.Element.Base.Mixin.SinkBehaviour.def_input_pad/2`,
`Membrane.Element.Base.Mixin.SourceBehaviour.def_output_pad/2` and `Membrane.Element.Base.Mixin.CommonBehaviour.def_options/1`)
and implement at least required callbacks.