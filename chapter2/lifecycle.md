# Element lifecycle

Proper resource management is crucial when creating reliable and stable software. For this purpose, Membrane Framework introduces few rules that unify expected behaviour of elements, so it is possible to manage them better (i.e. in pipelines). The main tool for this is a `playback state`. Elements should react to every state change and know exactly what should be done at the specific time of their "life". These rules are described in this chapter.

## Description of states and state changes

### Callback handle_init

Above callback is invoked only once, upon the element creation.
It receives options specified by the user, which should be parsed and on their base, the element should create and initialize its internal state.

### State stopped

It is the first and the last state of every element. While being in it, elements should not have any "dynamic" resources, open files or devices.
Elements in the `stopped` state might still not be linked, thus they shouldn't return from callbacks any actions that require sending any message via link (like caps and events).

### Stopped -> prepared change

It is a good place to allocate all needed resources (for example native resources). Elements in pipelines are already linked when performing this callback. If it is possible to know the capabilities of processed streams, they should be sent to other elements via :caps action.

### State prepared

Elements should have already all needed resources allocated in order to process data. Although all timers should be still stopped and waiting for the stream start. Elements are permitted to send caps and events via their pads, but sticky events will be queued in a pull buffer and processed after state change to the `playing`. Nevertheless, other events (not sticky) will be handled with `handle_event`.

From this state, it is possible to transit to both 'stopped' and 'playing' states. Elements should be prepared for both of these changes and don't assume any of them.

### Prepared -> playing change

If an element is based on a timer, it should be started in `handle_prepared_to_playing` callback.
Also, most Sinks should make their first demand in this callback.

### State playing

Elements are processing data, timers are running. Sending buffers and demands is allowed now.

### Playing -> prepared change

In callback handling this change, the element should stop all running timers.
Since this moment, elements won't process any more buffers or sticky events. All the data waiting in PullBuffers will be dropped.

### Prepared -> stopped change

When handling this change, all allocated resources should be cleaned, devices closed. The internal state of an element should be ready for the next transition to `prepared` state.
