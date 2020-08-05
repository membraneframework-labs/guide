# Coding style

- Use Elixir formatter (`mix format`). `.formatter.exs` should contain `:membrane_core` in `:import_deps`.
- Use Dialyzer (via `:dialyxir` dependency and `mix dialyzer` command) and make sure it shows no warnings.
- Use Credo with the config taken from [`membrane_template_plugin`](https://github.com/membraneframework/membrane_template_plugin/blob/master/.credo.exs)
- Indent with 2 spaces, use `LF` as end of line and `utf-8` encoding
- For native code, use `clang-format` with config (`.clang-format`):

  ```
  BasedOnStyle: LLVM
  IndentWidth: 2
  ```

- Avoid ambiguous abbreviations (e.g. `res`) and unnamed ignored variables (e.g. `def handle_init(_)` -> `def handle_init(_options)`) [enforced by Credo]
- When implementing something defined in some kind of document or standard (e.g. RFC) try to match variable names as closely as possible to the standard and always provide a reference in a comment
- Every public module must have `@moduledoc` and its public functions both `@doc` and `@spec` [enforced by Credo]
- Modules should have the following layout [enforced by Credo]:
  - `@moduledoc`
  - `@behaviour`
  - `use`
  - `import`
  - `alias`
  - `require`
  - `@module_attribute`
  - `defstruct`
  - `@type`
  - `@callback`
  - `@macrocallback`
  - `@optional_callbacks`
  - `defmacro`, `defguard`, `def`, etc.
- Always use `@impl` when implementing behaviour. Apply it to every function clause to avoid situations where the last clause has a typo that is not reported as warning since its treated as different function
- Read and follow the official [documentation writing](https://hexdocs.pm/elixir/writing-documentation.html) and [library creation](https://hexdocs.pm/elixir/library-guidelines.html) guides.
- Make sure the generated docs look well. Run `mix docs` and open `doc/index.html` in your browser. Configure properly `:nest_modules_by_prefix` and `:groups_for_modules` options in `mix.exs` (see [`ex_doc` docs](https://hexdocs.pm/ex_doc/Mix.Tasks.Docs.html) for reference)

## Naming Conventions

- Pure Elixir plugins:
  - Repo: `membrane_X_plugin` where X is format/protocol name (e.g. `membrane_mpegts_plugin`)
  - Application: `:membrane_X_plugin`
  - Modules: `Membrane.X.*` (e.g. `Membrane.AAC.Parser`)
- Plugins wrapping native library:
  - Repo: `membrane_X_LIB_plugin` where X is format/protocol name and LIB - the library (e.g. `membrane_aac_fdk_plugin`)
  - Application: `:membrane_X_LIB_plugin`
  - Modules: `Membrane.X.LIB.*` (e.g. `Membrane.AAC.FDK.Decoder`)
- Format definition (former caps):
  - Repo: `membrane_X_format` where X is the format name (e.g. `membrane_aac_format`)
  - Application: `:membrane_X_format`
  - Format struct: `%Membrane.X{}` (e.g. `%Membrane.AAC{channels: 2}`)
  - Other modules: `Membrane.X.*`, the same namespace as plugins for this format (e.g. `Membrane.AAC.*`)
