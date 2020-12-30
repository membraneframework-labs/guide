# Membrane packages

> If you see any out-of-date information or an invalid link here, feel free to create an issue or open a PR in [the guide repository](https://github.com/membraneframework/guide)

To improve modularity, Membrane is split into multiple packages. Here we gathered all of the official ones and keep adding third-party ones too, so if you created a Membrane plugin or other Membrane-based library, let us know!
We use the following [tags] in package descriptions:
- [In progress] - in active development, but not yet ready
- [Experimental] - possible to use, but may lack some core features/tests/documentation
- [Alpha] - ready to use, but may lack some features or need more testing
- [Third party] - maintained by the community
- [Suspended] - not ready and development was suspended

Check the [Membrane GitHub organization](https://github.com/membraneframework) to see which packages are actively developed currently.

## Demos
All the official Membrane demos reside in the [membrane demo](https://github.com/membraneframework/membrane_demo) package. They are:
- [Basic demos](https://github.com/membraneframework/membrane_demo/tree/master/basic)
- [RTP demo](https://github.com/membraneframework/membrane_demo/tree/master/rtp)
- [Receiving RTP stream and publishing it via HLS](https://github.com/membraneframework/membrane_demo/tree/master/rtp)
- [WebRTC signaling server demo](https://github.com/membraneframework/membrane_demo/tree/master/webrtc)

## Docker

The Membrane docker ([Docker Hub](https://hub.docker.com/r/membrane/membrane), [GitHub](https://github.com/membraneframework/docker_membrane)) contains Erlang, Elixir and libraries necessary to test and run the Membrane Framework.

## Media agnostic packages

| Package             | Description                                                                     | Links                                                                                                                                                          |
| ------------------- | ------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `membrane_core`     | The core of the framework                                                       | [Hex](https://hex.pm/packages/membrane_core) [Docs](https://hexdocs.pm/membrane_core) [GitHub](https://github.com/membraneframework/membrane_core)             |
| `membrane_common_c` | Utilities for the native parts of Membrane                                      | [Hex](https://hex.pm/packages/membrane_common_c) [Docs](https://hexdocs.pm/membrane_common_c) [GitHub](https://github.com/membraneframework/membrane_common_c) |
| `bundlex`           | Tool for compiling C/C++ code within Mix projects                               | [Hex](https://hex.pm/packages/bundlex) [Docs](https://hexdocs.pm/bundlex) [GitHub](https://github.com/membraneframework/bundlex)                               |
| `unifex`            | Tool automatically generating NIF and CNode interfaces between C/C++ and Elixir | [Hex](https://hex.pm/packages/unifex) [Docs](https://hexdocs.pm/unifex) [GitHub](https://github.com/membraneframework/unifex)                                  |
| `bunch`             | Extension of Elixir standard library                                            | [Hex](https://hex.pm/packages/bunch) [Docs](https://hexdocs.pm/bunch) [GitHub](https://github.com/membraneframework/bunch)                                     |
| `sebex`             | The ultimate assistant in Membrane Framework releasing & development            | [GitHub](https://github.com/membraneframework/sebex)                                                                                                           |

## Plugins

### Media agnostic

| Package                     | Description                                                                                          | Links                                                                                                                                                                               |
| --------------------------- | ---------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `membrane_file_plugin`      | Plugin for reading and writing to files                                                              | [Hex](https://hex.pm/packages/membrane_file_plugin) [Docs](https://hexdocs.pm/membrane_file_plugin) [GitHub](https://github.com/membraneframework/membrane_file_plugin)             |
| `membrane_element_udp`      | Plugin for sending and receiving UDP streams                                                         | [Hex](https://hex.pm/packages/membrane_element_udp) [Docs](https://hexdocs.pm/membrane_element_udp) [GitHub](https://github.com/membraneframework/membrane_element_udp)             |
| `membrane_hackney_plugin`   | HTTP sink and source based on Hackney library                                                        | [Hex](https://hex.pm/packages/membrane_hackney_plugin) [Docs](https://hexdocs.pm/membrane_hackney_plugin) [GitHub](https://github.com/membraneframework/membrane_hackney_plugin)    |
| `membrane_element_fake`     | Fake Membrane sinks that drop incoming data                                                          | [Hex](https://hex.pm/packages/membrane_element_fake) [Docs](https://hexdocs.pm/membrane_element_fake) [GitHub](https://github.com/membraneframework/membrane_element_fake)          |
| `membrane_scissors_plugin`  | Element for cutting off parts of the stream                                                          | [Hex](https://hex.pm/packages/membrane_scissors_plugin) [Docs](https://hexdocs.pm/membrane_scissors_plugin) [GitHub](https://github.com/membraneframework/membrane_scissors_plugin) |
| `membrane_element_tee`      | Plugin for splitting data from a single input to multiple outputs                                    | [Hex](https://hex.pm/packages/membrane_element_tee) [Docs](https://hexdocs.pm/membrane_element_tee) [GitHub](https://github.com/membraneframework/membrane_element_tee)             |
| `membrane_funnel_plugin`    | Plugin for merging multiple input streams into a single output                                       | [Hex](https://hex.pm/packages/membrane_funnel_plugin) [Docs](https://hexdocs.pm/membrane_funnel_plugin) [GitHub](https://github.com/membraneframework/membrane_funnel_plugin)       |
| `membrane_realtimer_plugin` | [In progress] Membrane element limiting playback speed to realtime, according to buffers' timestamps | [GitHub](https://github.com/membraneframework/membrane_realtimer_plugin)                                                                                                            |
| `membrane_element_pcap`     | [Experimental]                                                                                       | [GitHub](https://github.com/membraneframework/membrane-element-pcap)                                                                                                                |

### Media network protocols & containers

| Package                                | Description                                                                                      | Links                                                                                                                                                                                                                   |
| -------------------------------------- | ------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `membrane_rtp_plugin`                  | Membrane bins and elements for handling RTP and RTCP streams                                     | [Hex](https://hex.pm/packages/membrane_rtp_plugin) [Docs](https://hexdocs.pm/membrane_rtp_plugin) [GitHub](https://github.com/membraneframework/membrane_rtp_plugin)                                                    |
| `membrane_rtp_aac_plugin`              | [Alpha] RTP AAC depayloader                                                                      | [Hex](https://hex.pm/packages/membrane_rtp_aac_plugin) [Docs](https://hexdocs.pm/membrane_rtp_aac_plugin) [GitHub](https://github.com/membraneframework/membrane_rtp_aac_plugin)                                        |
| `membrane_rtp_h264_plugin`             | RTP H.264 depayloader                                                                            | [Hex](https://hex.pm/packages/membrane_rtp_h264_plugin) [Docs](https://hexdocs.pm/membrane_rtp_h264_plugin) [GitHub](https://github.com/membraneframework/membrane_rtp_h264_plugin)                                     |
| `membrane_rtp_mpegaudio_plugin`        | Set of elements for payloading and depayloading MPEG Audio                                       | [Hex](https://hex.pm/packages/membrane_rtp_mpegaudio_plugin) [Docs](https://hexdocs.pm/membrane_rtp_mpegaudio_plugin) [GitHub](https://github.com/membraneframework/membrane_rtp_mpegaudio_plugin)                      |
| `membrane_rtp_opus_plugin`             | RTP OPUS depayloader                                                                             | [Hex](https://hex.pm/packages/membrane_rtp_opus_plugin) [Docs](https://hexdocs.pm/membrane_rtp_opus_plugin) [GitHub](https://github.com/membraneframework/membrane_rtp_opus_plugin)                                     |
| `membrane_mpegts_plugin`               | MPEG-TS demuxer                                                                                  | [Hex](https://hex.pm/packages/membrane_mpegts_plugin) [Docs](https://hexdocs.pm/membrane_mpegts_plugin) [GitHub](https://github.com/membraneframework/membrane_mpegts_plugin)                                           |
| `membrane_mp4_plugin`                  | Utilities for MP4 container parsing and serialization and elements for muxing the stream to CMAF | [Hex](https://hex.pm/packages/membrane_mp4_plugin) [Docs](https://hexdocs.pm/membrane_mp4_plugin) [GitHub](https://github.com/membraneframework/membrane_mp4_plugin)                                                    |
| `membrane_http_adaptive_stream_plugin` | Plugin generating manifests for HLS (DASH support planned)                                       | [Hex](https://hex.pm/packages/membrane_http_adaptive_stream_plugin) [Docs](https://hexdocs.pm/membrane_http_adaptive_stream_plugin) [GitHub](https://github.com/membraneframework/membrane_http_adaptive_stream_plugin) |
| `membrane_ice_plugin`                  | Plugin for ICE protocol                                                                          | [Hex](https://hex.pm/packages/membrane_ice_plugin) [Docs](https://hexdocs.pm/membrane_ice_plugin) [GitHub](https://github.com/membraneframework/membrane_ice_plugin)                                                    |
| `membrane_dtls_plugin`                 | DTLS and DTLS-SRTP handshake implementation for Membrane ICE plugin                              | [Hex](https://hex.pm/packages/membrane_dtls_plugin) [Docs](https://hexdocs.pm/membrane_dtls_plugin) [GitHub](https://github.com/membraneframework/membrane_dtls_plugin)                                                 |
| `membrane_element_icecast`             | [Experimental] Element capable of sending a stream into Icecast streaming server                 | [GitHub](https://github.com/membraneframework/membrane-element-icecast)                                                                                                                                                 |


### Audio codecs

| Package                           | Description                                                  | Links                                                                                                                                                                                                    |
| --------------------------------- | ------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `membrane_aac_plugin`             | AAC parser and complementary elements for AAC codec          | [Hex](https://hex.pm/packages/membrane_aac_plugin) [Docs](https://hexdocs.pm/membrane_aac_plugin) [GitHub](https://github.com/membraneframework/membrane_aac_plugin)                                     |
| `membrane_aac_fdk_plugin`         | AAC decoder and encoder based on FDK library                 | [Hex](https://hex.pm/packages/membrane_aac_fdk_plugin) [Docs](https://hexdocs.pm/membrane_aac_fdk_plugin) [GitHub](https://github.com/membraneframework/membrane_aac_fdk_plugin)                         |
| `membrane_element_flac_parser`    | Parser for files in FLAC bitstream format                    | [Hex](https://hex.pm/packages/membrane_element_flac_parser) [Docs](https://hexdocs.pm/membrane_element_flac_parser) [GitHub](https://github.com/membraneframework/membrane-element-flac-parser)          |
| `membrane_mp3_lame_plugin`        | Membrane MP3 encoder based on Lame                           | [Hex](https://hex.pm/packages/membrane_mp3_lame_plugin) [Docs](https://hexdocs.pm/membrane_mp3_lame_plugin) [GitHub](https://github.com/membraneframework/membrane_mp3_lame_plugin)                      |
| `membrane_mp3_mad_plugin`         | Membrane MP3 decoder based on MAD                            | [Hex](https://hex.pm/packages/membrane_mp3_mad_plugin) [Docs](https://hexdocs.pm/membrane_mp3_mad_plugin) [GitHub](https://github.com/membraneframework/membrane_mp3_mad_plugin)                         |
| `membrane_element_mpegaudioparse` | Element capable of parsing bytestream into MPEG audio frames | [Hex](https://hex.pm/packages/membrane_element_mpegaudioparse) [Docs](https://hexdocs.pm/membrane_element_mpegaudioparse) [GitHub](https://github.com/membraneframework/membrane-element-mpegaudioparse) |
| `membrane_opus_plugin`            | Opus encoder and decoder                                     | [Hex](https://hex.pm/packages/membrane_opus_plugin) [Docs](https://hexdocs.pm/membrane_opus_plugin) [GitHub](https://github.com/membraneframework/membrane_opus_plugin)                                  |
| `membrane_element_flac_encoder`   | [Suspended]                                                  | [GitHub](https://github.com/membraneframework/membrane-element-flac-encoder)                                                                                                                             |


### Video codecs

| Package                       | Description                                                              | Links                                                                                                                                                                                        |
| ----------------------------- | ------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `membrane_h264_ffmpeg_plugin` | Membrane H264 parser, decoder and encoder based on FFmpeg and x264       | [Hex](https://hex.pm/packages/membrane_h264_ffmpeg_plugin) [Docs](https://hexdocs.pm/membrane_h264_ffmpeg_plugin) [GitHub](https://github.com/membraneframework/membrane_h264_ffmpeg_plugin) |
| `turbojpeg`                   | [Third-party] libjpeg-turbo bindings for Elixir by Binary Noggin         | [Hex](https://hex.pm/packages/turbojpeg) [Docs](https://hexdocs.pm/turbojpeg/readme.html) [GitHub](https://github.com/binarynoggin/elixir-turbojpeg)                                         |
| `membrane_element_msdk_h264`  | [Experimental] Hardware-accelerated H.264 encoder based on IntelMediaSDK | [GitHub](https://github.com/membraneframework/membrane-element-msdk-h264)                                                                                                                    |


### Raw audio

| Package                             | Description                                                                                                  | Links                                                                                                                                                                                                          |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `membrane_portaudio_plugin`         | Raw audio retriever and player based on PortAudio                                                            | [Hex](https://hex.pm/packages/membrane_portaudio_plugin) [Docs](https://hexdocs.pm/membrane_portaudio_plugin) [GitHub](https://github.com/membraneframework/membrane_portaudio_plugin)                         |
| `membrane_ffmpeg_swresample_plugin` | Plugin performing audio conversion, resampling and channel mixing, using SWResample module of FFmpeg library | [Hex](https://hex.pm/packages/membrane_ffmpeg_swresample_plugin) [Docs](https://hexdocs.pm/membrane_ffmpeg_swresample_plugin) [GitHub](https://github.com/membraneframework/membrane_ffmpeg_swresample_plugin) |
| `membrane_audiometer_plugin`        | Elements for measuring the level of the audio stream                                                         | [Hex](https://hex.pm/packages/membrane_audiometer_plugin) [Docs](https://hexdocs.pm/membrane_audiometer_plugin) [GitHub](https://github.com/membraneframework/membrane_audiometer_plugin)                      |
| `membrane_element_live_audiomixer`  | [Experimental]                                                                                               | [GitHub](https://github.com/membraneframework/membrane-element-live-audiomixer)                                                                                                                                |
| `membrane_element_fade`             | [Experimental]                                                                                               | [GitHub](https://github.com/membraneframework/membrane-element-fade)                                                                                                                                           |


### Raw video

| Package                            | Description                          | Links                                                                                                                                                                                                       |
| ---------------------------------- | ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `membrane_sdl_plugin`              | Membrane video player based on SDL   | [Hex](https://hex.pm/packages/membrane_sdl_plugin) [Docs](https://hexdocs.pm/membrane_sdl_plugin) [GitHub](https://github.com/membraneframework/membrane_sdl_plugin)                                        |
| `membrane_element_rawvideo_parser` | Plugin for parsing raw video streams | [Hex](https://hex.pm/packages/membrane_element_rawvideo_parser) [Docs](https://hexdocs.pm/membrane_element_rawvideo_parser) [GitHub](https://github.com/membraneframework/membrane_element_rawvideo_parser) |


### External APIs
| Package                                  | Description                                                              | Links                                                                                                                                                                                                                         |
| ---------------------------------------- | ------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `membrane_element_gcloud_speech_to_text` | Plugin providing speech recognition via Google Cloud Speech-to-Text API  | [Hex](https://hex.pm/packages/membrane_element_gcloud_speech_to_text) [Docs](https://hexdocs.pm/membrane_element_gcloud_speech_to_text) [GitHub](https://github.com/membraneframework/membrane_element_gcloud_speech_to_text) |
| `membrane_element_ibm_speech_to_text`    | Plugin providing speech recognition via IBM Cloud Speech-to-Text service | [Hex](https://hex.pm/packages/membrane_element_ibm_speech_to_text) [Docs](https://hexdocs.pm/membrane_element_ibm_speech_to_text) [GitHub](https://github.com/membraneframework/membrane_element_ibm_speech_to_text)          |


## Formats

| Package                    | Description                                    | Links                                                                                                                                                                               |
| -------------------------- | ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `membrane_aac_format`      | Advanced Audio Codec format definition         | [Hex](https://hex.pm/packages/membrane_aac_format) [Docs](https://hexdocs.pm/membrane_aac_format) [GitHub](https://github.com/membraneframework/membrane_aac_format)                |
| `membrane_mp4_format`      | MPEG-4 container format definition             | [Hex](https://hex.pm/packages/membrane_mp4_format) [Docs](https://hexdocs.pm/membrane_mp4_format) [GitHub](https://github.com/membraneframework/membrane_mp4_format)                |
| `membrane_opus_format`     | Opus audio format definition                   | [Hex](https://hex.pm/packages/membrane_opus_format) [Docs](https://hexdocs.pm/membrane_opus_format) [GitHub](https://github.com/membraneframework/membrane_opus_format)             |
| `membrane_rtp_format`      | Real-time Transport Protocol format definition | [Hex](https://hex.pm/packages/membrane_rtp_format) [Docs](https://hexdocs.pm/membrane_rtp_format) [GitHub](https://github.com/membraneframework/membrane_rtp_format)                |
| `membrane_caps_audio_flac` | FLAC audio format definition                   | [Hex](https://hex.pm/packages/membrane_caps_audio_flac) [Docs](https://hexdocs.pm/membrane_caps_audio_flac) [GitHub](https://github.com/membraneframework/membrane-caps-audio-flac) |
| `membrane_caps_audio_mpeg` | MPEG audio format definition                   | [Hex](https://hex.pm/packages/membrane_caps_audio_mpeg) [Docs](https://hexdocs.pm/membrane_caps_audio_mpeg) [GitHub](https://github.com/membraneframework/membrane-caps-audio-mpeg) |
| `membrane_caps_audio_raw`  | Raw audio format definition                    | [Hex](https://hex.pm/packages/membrane_caps_audio_raw) [Docs](https://hexdocs.pm/membrane_caps_audio_raw) [GitHub](https://github.com/membraneframework/membrane-caps-audio-raw)    |
| `membrane_caps_video_h264` | H264 video format definition                   | [Hex](https://hex.pm/packages/membrane_caps_video_h264) [Docs](https://hexdocs.pm/membrane_caps_video_h264) [GitHub](https://github.com/membraneframework/membrane-caps-video-h264) |
| `membrane_caps_video_raw`  | Raw video format definition                    | [Hex](https://hex.pm/packages/membrane_caps_video_raw) [Docs](https://hexdocs.pm/membrane_caps_video_raw) [GitHub](https://github.com/membraneframework/membrane-caps-video-raw)    |



## Apps, protocols & plugins' utilities

| Package                     | Description                                                                            | Links                                                                                                                                                                |
| --------------------------- | -------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `membrane_webrtc_server`    | Signaling server for WebRTC                                                            | [Hex](https://hex.pm/packages/membrane_webrtc_server) [Docs](https://hexdocs.pm/membrane_webrtc_server) [GitHub](https://github.com/membraneframework/webrtc-server) |
| `ex_sdp`                    | Parser and serializer for Session Description Protocol                                 | [Hex](https://hex.pm/packages/ex_sdp) [Docs](https://hexdocs.pm/ex_sdp) [GitHub](https://github.com/membraneframework/ex_sdp)                                        |
| `ex_libnice`                | Libnice-based Interactive Connectivity Establishment (ICE) protocol support for Elixir | [Hex](https://hex.pm/packages/ex_libnice) [Docs](https://hexdocs.pm/ex_libnice) [GitHub](https://github.com/membraneframework/ex_libnice)                            |
| `ex_dtls`                   | DTLS and DTLS-SRTP handshake library for Elixir, based on OpenSSL                      | [Hex](https://hex.pm/packages/ex_dtls) [Docs](https://hexdocs.pm/ex_dtls) [GitHub](https://github.com/membraneframework/ex_dtls)                                     |
| `membrane_rtsp`             | RTSP client for Elixir                                                                 | [GitHub](https://github.com/membraneframework/membrane-protocol-rtsp)                                                                                                |
| `membrane_common_audiomix`  | [Experimental]                                                                         | [GitHub](https://github.com/membraneframework/membrane-common-audiomix)                                                                                              |
| `membrane_protocol_icecast` | [Suspended]                                                                            | [GitHub](https://github.com/membraneframework/membrane-protocol-icecast)                                                                                             |
| `membrane_server_icecast`   | [Suspended]                                                                            | [GitHub](https://github.com/membraneframework/membrane-server-icecast)                                                                                               |



## Deprecated

| Package                              | Description                           | Links                                                                                                                                                                                     |
| ------------------------------------ | ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `membrane_bin_rtp`                   | Moved to `membrane_rtp_plugin`        | [Hex](https://hex.pm/packages/membrane_bin_rtp) [Docs](https://hexdocs.pm/membrane_bin_rtp) [GitHub](https://github.com/membraneframework/membrane-bin-rtp)                               |
| `membrane_element_rtp`               | Moved to `membrane_rtp_plugin`        | [Hex](https://hex.pm/packages/membrane_element_rtp) [Docs](https://hexdocs.pm/membrane_element_rtp) [GitHub](https://github.com/membraneframework/membrane-element-rtp)                   |
| `membrane_element_rtp_jitter_buffer` | Moved to `membrane_rtp_plugin`        | [GitHub](https://github.com/membraneframework/membrane-element-rtp-jitter-buffer)                                                                                                         |
| `membrane_element_httpoison`         | Use `membrane_hackney_plugin` instead | [Hex](https://hex.pm/packages/membrane_element_httpoison) [Docs](https://hexdocs.pm/membrane_element_httpoison) [GitHub](https://github.com/membraneframework/membrane-element-httpoison) |



