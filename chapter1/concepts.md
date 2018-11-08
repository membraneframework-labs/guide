# Elements

Elements in Membrane Framework are the most basic entities. They are represented by their own Erlang process, that has internal state and communicates by message passing.

Every Element is created to solve some problem. The examples of the element may be one of those: audio decoder(converting raw audio to encoded format), file source (reading data from a file and passing it to other elements) or UDP sink (sending data from an application via UDP socket).

Elements define their own `options` that parametrize their work. For example, some audio decoder may have an option named `bitrate` that represents bitrate of the output data.

There are three basic types of elements: `sink`, `source`, and `filters`:

* `Source` - responsible for delivering data to other elements
* `Sink` - defines an endpoint for data flowing in an application.
* `Filter` - an element that receives data from other elements, processes it and sends it further to the next elements

Every element may be in one of three states:

* `:stopped` - element has been created
* `:prepared` - element should be ready for processing data. All necessary resources should be allocated and initialized.
* `:playing` - element is actually processing data

## Pads and capabilities

To create the flow of data between elements in the application, they have to communicate with each other. For that purpose, the concept of `pads` and `capabilities` is used. `Pads` are basically inputs and outputs of the elements and because of that, there are two types of pads: `input` and `output`. It is worth mentioning that `Source` elements may only contain `output` pads, `Sinks` contain only `input` pads, and `Filters` can have both of them.

Every pad has some capabilities, which defines a type of data that it is expecting. This format can be, for example, raw audio with a specific sample rate or encoded audio in a given format.

Two elements that should send data between each other, should have linked pads. One pad can be linked with only one other pad of a different element. Only links between `output` and `input` pads are allowed. Furthermore, to link two pads, their capabilities have to be compatible.

## Pipelines

A pipeline is a container that consists of many elements and links between them. Like an Element, every Pipeline also has a playback state and on its basis, it manages the state of the contained elements.

During the application execution, elements may want to signal some events. For that purpose, they send the `notification` to their supervisor, which in most cases is a pipeline. A programmer can handle those notifications by defining the appropriate method in the pipeline module.
