# Logging

Apart from usual `Logger` configuration, logging in Membrane can be additionally configured, also via Elixir's `Config`. It allows to enable verbose mode and customize metadata, for example:

```elixir
config :membrane_core, :logger, verbose: true
```

See `Membrane.Logger` for details.

Moreover, pipelines support `t:Membrane.Pipeline.Action.log_metadata_t/0`, that enables setting logger metadata to all descendants of a pipeline, for example:

```elixir
@impl true
def handle_init(opts) do
  # ...
  {{:ok, log_metadata: [pipeline_id: opts.id]}, state}
end
```

To have the metadata displayed, remember to enable that in the logger backend, for example:

```elixir
config :logger, :console, metadata: [:pipeline_id]
```

The `log_metadata` action is also available in bins: `t:Membrane.Bin.Action.log_metadata_t/0`.
