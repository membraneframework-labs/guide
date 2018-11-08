# Logger

Due to the performance issues, we implemented our own system for managing logs. It also allows filtering messages on the basis of `tags`, so it is possible to display only logs from the specific module or referring to the specific task.

## Usage

Just add `use Membrane.Mixins.Log` in your module. If you want to add the default tags to each logged message, you can pass them by macro's argument, i.e. `Membrane.Mixins.Log, tags: [:my_tag1, :my_tag2]`

Then, you can invoke functions `Logger.Debug`, `Logger.info`, `Logger.warn`, and `Logger.warn_error` in your module. Your logs will be sent to the router that will dispatch them to appropriate logger instances.

## Configuration

Logging configuration is stored in your app configuration file. Sample configuration looks like this:

```elixir

config :membrane_core, Membrane.Logger,
  loggers: [
    %{
      module: Membrane.Loggers.Console,
      id: :console,
      level: :debug,
      options: [],
      tags: [:all],
    }
  ],
  level: :info
```

`loggers` variable declares all logger instances that are created upon the application start. `level` is the minimal level of a log, that is sent to the router (changing this value requires recompilation to make changes). Selecting a higher level may improve the performance of your application.

You have to make sure, that logger module is available in your application. To use `Membrane.Loggers.Console`, you have to add it as a dependency to your `mix.exs`:

```elixir
{:membrane_loggers, "~> 0.2.0"}
```
