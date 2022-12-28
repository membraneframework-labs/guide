# Membrane Framework guide
Hello and welcome to the general guide to the Membrane Framework! 

Membrane is a multimedia processing framework that focuses on reliability, concurrency and scalability.
With the bunch of already existing packages and a convenient interface allowing to write your own one, 
almost any desired multimedia processing can be acheived with the use of Membrane.

Membrane is written mainly in Elixir, while some platform-specific or time-constrained parts are written in C.

## Structure of the Membrane Framework
The Membrane Framework allows you to define your own processing units - so called `elements`. In example, an element:
* might be capable of muxing the incoming audio and video streams into the container 
* might be able to play the raw audio with the use of your sound card.

You can organize the `elements` into a `pipeline` - a sequence of linked elements. Within a pipeline, the output of a preceeding  `element` is passed to the input of the following `element`. Pipelines are a powerful tool that allows you to deliver your desired processsing logic. An pipeline might, i.e.:
* receive the incoming RTSP stream from the webcamera, and convert it to the HLS stream
* act as a SFU (*Selective Forwarding Unit*), allowing you to implement your own videoconferencing room

### Membrane Core
The heart and the soul of the Membrane Framework is [Membrane Core]().
It written completly in Elixir and provides internal mechanisms and the developer's interfaces that allow for the preparation of the processing elements and linking them in a convenient yet reliable way. 
Keep in mind, that you won't find any multimedia specific logic within the Membrane Core!
The documentation of the developer's API is available [at hexdocs]().

### Membrane packages
Membrane packages are the one that deliver the multimedia processing logic.
The packages are organized in a domain-specific way - that means, that it's common that in a particular package named after the container name (i.e. membrane_mp4_plugin) you will find both the muxing and demuxing elements for a given container.

A complete list of all the Membrane packages managed by the Membrane team is available [here]().

## Where can I learn Membrane?
There are quite a few resources available! Each of them is oriented on a different aspect so take your time and search for the resources that fits you most.

### This guide
The [following sections in that guide]() will show you main concepts of creating Membrane elements and pipelines - at the same time, it won't focus on the multimedia aspect of the processing at all.

## Demos
The [membrane demos]() are available in form of a repository consisting of multiple subdirectories. In each of these subdirectories there is a single Elixir project. With the use of a brief instruction available in the subdirectory's README.md you will be able to launch the demo application, but you will need to inspect the code on your own to find out how the application works.

### Tutorials
Take a look [here]() and see some real-life use cases of the Membrane for multimedia processing in form of a tutorial, that will 
go step by step through the implementation of a desired system.

### Documentation
We can encourage you to seek for information in the [Membrane Core documentation]() and in the documentation of the Membrane packages, maintained by the Membrane team, available [here]().




If you see something requiring improvement in this guide, feel free to create an issue or open a PR in [this repository](https://github.com/membraneframework/guide). For more information about the framework and more tutorials, check our website: [membrane.stream](https://membrane.stream).


