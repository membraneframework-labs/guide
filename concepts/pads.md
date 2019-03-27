## Pads and capabilities

To create the flow of data between elements in the application, they have to communicate with each other. For that purpose, the concept of `pads` and `capabilities` is used. `Pads` are basically inputs and outputs of the elements and because of that, there are two types of pads: `input` and `output`. It is worth mentioning that `Source` elements may only contain `output` pads, `Sinks` contain only `input` pads, and `Filters` can have both of them.

Every pad has some capabilities, which defines a type of data that it is expecting. This format can be, for example, raw audio with a specific sample rate or encoded audio in a given format.

Two elements that should send data between each other, should have linked pads. One pad can be linked with only one other pad of a different element. Only links between `output` and `input` pads are allowed. Furthermore, to link two pads, their capabilities have to be compatible.