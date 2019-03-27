## Pipelines

A pipeline is a container that consists of many elements and links between them. Like an Element, every Pipeline also has a playback state and on its basis, it manages the state of the contained elements.

During the application execution, elements may want to signal some events. For that purpose, they send the `notification` to their supervisor, which in most cases is a pipeline. A programmer can handle those notifications by defining the appropriate method in the pipeline module.
