# Contributing Guide

## General contribution info
Any contributions to Membrane Framework are welcome. If you would like contribute, but you're not sure how to start or have some questions, don't hesitate to contact us via our [Discord](https://discord.gg/nwnfVSY).
<br>
For inquiries related to our commercial services or for other contact information, please visit [Membrane website](https://membrane.stream/contact) for more information.
<br>
When contributing to existing repo:
- fork it
- apply change on some branch with a meaningful name
- create a PR from fork to our repo
- await feedback from someone from the team
- after passing the review, the PR will be merged

<br>

If you wish to create a new plugin you can give us a shout and if it's something we want as a part of our ecosystem we'll create a repo for you, guide you on your work and maintain the plugin in future. However, if feel confident enough to maintain it on your own, you can, of course, create your own repo and hex package - we only ask you to follow the naming conventions of the framework package and modules. In that case, don't forget to let us know about your work so we could include it on the list of available plugins.

## Code style guide

- Base the package on [`membrane_template_plugin`](https://github.com/membraneframework/membrane_template_plugin). Use Elixir formatter, Dialyzer and Credo config specified there.
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
- When defining structs, set default values explicitly and omit brackets
```
  # not preferred
  defstruct [:name, :params, active: true]

  # preferred
  defstruct name: nil, params: nil, active: true
  ```
- Always use `@impl` when implementing behaviour. Apply it to every function clause to avoid situations where the last clause has a typo that is not reported as warning since its treated as different function
- Read and follow the official [documentation writing](https://hexdocs.pm/elixir/writing-documentation.html) and [library creation](https://hexdocs.pm/elixir/library-guidelines.html) guides.
- Make sure the generated docs look well. Run `mix docs` and open `doc/index.html` in your browser. Configure properly `:nest_modules_by_prefix` and `:groups_for_modules` options in `mix.exs` (see [`ex_doc` docs](https://hexdocs.pm/ex_doc/Mix.Tasks.Docs.html) for reference)
- Read and follow [elixir style guide](https://github.com/christopheradams/elixir_style_guide/blob/master/README.md). It applies in all the situations not mentioned above.

### Naming Conventions

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

## Contributing practices
When creating contribution:
- You can open a draft PR right away.
- If PR solves GH issue, remember to link the issue to the PR (either by adding Closes # and PR number or using the UI)
- When finished, make a self-review before assigning a reviewer.
- Remember to watch for comments accidentally marked as outdated and don't mark someone else's comments as resolved.
- When you consider all the comments fixed, re-request the review.
- Do not force push changes to the reviewed commits - this breaks `changes since last review` functionality on GH
- Always remove your branch after merging the PR. It should happen automatically. If not, ask someone with permissions to enable that in settings.