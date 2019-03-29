# Native code integration

Native code is used in Membrane Framework quite often. Most common use case is to access create a wrapper for a C library.
Since using NIFs has many drawbacks and can even crash Erlang virtual machine during the runtime, we use them only when absolutely necessary or it makes no sense to rewrite a complicated piece of code from scratch.

## [Bundlex](https://github.com/membraneframework/bundlex)

To simplify and unify the process of writing and compiling NIFs, we use our own build tool - Bundlex. It is a multi-platform tool that provides a convenient way of loading, compiling NIFs in elixir modules. For more information, please visit [Bundlex's GitHub page.](https://github.com/membraneframework/bundlex)

## [Unifex](https://github.com/membraneframework/unifex)

Generally, Writing NIFs require creating a lot of boilerplate code and programmer's efforts. To make this process more pleasant, Membrane Framework exports tool [Unifex](https://github.com/membraneframework/unifex) that is responsible for generating interfaces between simple C libraries and Elixir on the base of short `.exs` files.

A quick introduction to Unifex is available [here](https://hexdocs.pm/unifex/creating_unifex_nif.html).

## [Membrane Common C](https://github.com/membraneframework/membrane-common-c)

Membrane Framework also delivers some useful C routines which might be useful for creating many native modules. It exports the following functionalities:

* methods used for sending logs to `Membrane.Log.Router`
* implementation of RingBuffer
* abstraction over SHM payload (using [shmex](https://github.com/membraneframework/shmex))
