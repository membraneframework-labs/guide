# Native code integration

In Membrane we try to make use of Elixir goodness as often as possible. However, sometimes it is necessary to write some native code,
for example to integrate with existing native libraries. To achieve that, we use _natives_, which are either
[NIFs](http://erlang.org/doc/man/erl_nif.html) or [CNodes](http://erlang.org/doc/man/ei_connect.html).
Both of them have their drawbacks: CNodes introduce inter-process communication, while NIFs can even crash entire VM in case of failure.
That's why we use them only when necessary and created some tools to make dealing with them easier.

## [Bundlex](https://github.com/membraneframework/bundlex)

To simplify and unify the process of writing and compiling natives, we use our own build tool - Bundlex.
It is a multi-platform tool that provides a convenient way of compiling and accessing natives from Elixir code.
For more information, see [Bundlex's GitHub page](https://github.com/membraneframework/bundlex).

## [Unifex](https://github.com/membraneframework/unifex)

Process of creating natives is not only difficult but also quite arduous, because it requires using cumbersome Erlang APIs,
and thus a lot of boilerplate code. To make it more pleasant, Membrane Framework provides
[Unifex](https://github.com/membraneframework/unifex), a tool that is responsible for generating interfaces between
simple C libraries and Elixir on the base of short `.exs` configuration files. Unifex currently supports only NIFs,
but support for CNodes is planned.

A quick introduction to Unifex is available [here](https://hexdocs.pm/unifex/creating_unifex_nif.html).

## [Membrane Common C](https://github.com/membraneframework/membrane-common-c)

Membrane Framework also delivers some useful C routines which might be useful for creating natives.
[Membrane Common C](https://github.com/membraneframework/membrane-common-c) package exports the following functionalities:

* an interface to Membrane logger,
* a [ringbuffer](https://en.wikipedia.org/wiki/Circular_buffer),
* implementation of `Membrane.Payload.Behaviour` wrapping [Shmex](https://github.com/membraneframework/shmex)) allowing to
  use shared memory segments as payload in Membrane elements.
