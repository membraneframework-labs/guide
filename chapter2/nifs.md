# NIFs

NIFs (Native Implemented Functions) are used in Membrane Framework as a wrappers for C libraries.
Since using NIFs has many drawback and can even crash Erlang virtual machine during the runtime, we use them only when absolutely necessary or it makes no sense to rewrite complicated piece of code from scratch.

## Bundlex

To simplify and unify the process of writing and compiling NIFs, we use our own build tool - [Bundlex](https://github.com/radiokit/bundlex). It is multi-platform tool that provides convenient way of loading, compiling NIFs in elixir modules. For more informations, please visit the Bundlex's github page.


## Membrane Common

Membrane Framework also delivers some useful C routines which might be useful for creating many native modules. It exports the following functionalities:
* parsing arguments passed to NIFs and serializing sample formats from our Elixir representation to 32bit format
* utility for creating return terms
* methods used for sending logs to Membrane.Log.Router
* implementation of RingBuffer 

