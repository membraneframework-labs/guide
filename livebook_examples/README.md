# Livebook examples 

This repository contains examples of using many Membrane modules and libraries.


## VideoCompositor

This [Livebook](./video_compositor/video_compositor.livemd) shows how to use [Video Compositor](https://hexdocs.pm/membrane_video_compositor_plugin) module to create a video stream from multiple dynamic video sources.


## Installation procedure

1. Install Livebook

    It is recommended to install Livebook via command line ([see official installation guide](https://github.com/livebook-dev/livebook#escript)). 

    If livebook was installed directly from the official page, one should add `$PATH` variable to the Livebook environment:
    ![Setting path](./assets/path_set.png "Title")

2. Install modules' native dependencies:

    - [Video Compositor](https://github.com/membraneframework/membrane_video_compositor_plugin#installation)
    - [Opus](https://github.com/membraneframework/membrane_opus_plugin#installation)
    - [FFmpeg](https://ffmpeg.org/download.html)



