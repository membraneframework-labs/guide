# Pipelines

Conceptually, a pipeline is a container that consists of many elements and links between them.
Like an element, every pipeline has a playback state (and uses the same callbacks to handle transitions between them).
It's an Erlang process responsible for starting elements (usually referred to as children) and
managing their playback state to match the one set for the pipeline.

## Communication with children

During the application execution, elements may want to signal some events. For that purpose, they send the
`Notification` to their watcher, which in most cases is a pipeline.

A pipeline can also a gateway to an element - as elements' pids aren't available globally pipeline can route messages
to children using names defined at pipeline creation.

## Defining pipelines

Pipelines are Elixir modules that use `Membrane.Pipeline` and implement callbacks required by `Membrane.Pipeline` behaviour.