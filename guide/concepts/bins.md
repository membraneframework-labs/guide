# Bins

Bins, similarly to pipelines, are containers for elements. However, at the same time,
they can be placed and linked within pipelines. Although bin is a separate
Membrane entity, it can be perceived as a pipeline within an element.
Bins can also be nested within one another.

There are two main reasons why bins are useful:
- they enable creating reusable element groups
- they allow managing their children, for instance by dynamically spawning
or replacing them as the stream changes.

## Pads

Bin's pads are defined similarly to element's pads and can be linked the same way.
However, their role is limited to proxy the stream to elements and bins inside (inputs)
or outside (outputs). To achieve that, each input pad of a bin needs to be linked
to both an output pad from the outside of a bin and an input pad of its child inside.
Accordingly, each bin's output should be linked to output inside and input outside of the bin.

## Bins and the stream

Although the bin passes the stream through its pads, it does not access it directly,
so that callbacks such as `handle_process` or `handle_event` are not found there.
This is because the responsibility of the bin is to manage its children, not to
process the stream. Whatever the bin needs to know about the stream, it should
get via notifications from the children.

## Bins as black boxes

Bins are designed to take as much responsibility for their children as possible
so that pipelines (or parent bins) don't have to depend on them.
That's why notifications from the children are sent to their parent bin only
(or to the pipeline in case of top-level elements or bins). Also, messages
received by a bin or pipeline can be forwarded only to its direct children.
