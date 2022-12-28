# Membrane Framework guide
Hello and welcome to the general guide to the Membrane Framework!

Membrane is a multimedia processing framework that focuses on reliability, concurrency, and scalability. It is primarily written in Elixir, while some platform-specific or time-constrained parts are written in C. With a range of existing packages and an easy-to-use interface for writing your own, Membrane can be used to process almost any type of multimedia.

## Structure of the Membrane Framework
The Membrane Framework allows you to define your own processing units, called "elements." An element might be able to mux incoming audio and video streams into a container, or play raw audio using your sound card.

Elements can be organized into a "pipeline," which is a sequence of linked elements that performs a specific task. For example, a pipeline might receive an incoming RTSP stream from a webcam and convert it to an HLS stream, or act as a selective forwarding unit (SFU) to implement your own videoconferencing room.

### Membrane Core
[Membrane Core]() is the heart and soul of the Membrane Framework. It is written entirely in Elixir and provides the internal mechanisms and developer's interfaces that allow you to prepare processing elements and link them together in a convenient yet reliable way. Note that Membrane Core does not contain any multimedia-specific logic. 
The documentation for the developer's API is available at [hexdocs]().

### Membrane packages
Membrane packages provide the multimedia processing logic. They are organized by domain, so a package named after a container (e.g. membrane_mp4_plugin) might contain elements for muxing and demuxing that container. A complete list of all the Membrane packages managed by the Membrane team is available here.

A complete list of all the Membrane packages managed by the Membrane team is available [here]().

## Where can I learn Membrane?
There are a number of resources available for learning about Membrane:

### This guide
The [following sections in that guide]() will introduce the main concepts of creating Membrane elements and pipelines, without focusing on the specific details of multimedia processing.

### Demos
The membrane demos are available in a repository with multiple subdirectories, each containing a single Elixir project. Each subdirectory includes instructions for running the demo application, but you will need to examine the code to understand how it works. To access the demos, follow [this link]().

### Tutorials
For a step-by-step guide to implementing a specific system using Membrane, check out our [tutorials]().

### Documentation
For more detailed information, you can refer to the Membrane Core documentation and the documentation for the Membrane packages maintained by the Membrane team, both of which are available [here]().


If you see something requiring improvement in this guide, feel free to create an issue or open a PR in [this repository](https://github.com/membraneframework/guide). For more information about the framework and more tutorials, check our website: [membrane.stream](https://membrane.stream).
