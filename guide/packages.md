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
All the official Membrane demos reside in the [membrane-demo](https://github.com/membraneframework/membrane-demo) package. They are:
- [Basic demos](https://github.com/membraneframework/membrane-demo/tree/master/basic)
- [RTP demo](https://github.com/membraneframework/membrane-demo/tree/master/rtp)
- [Receiving RTP stream and publishing it via HLS](https://github.com/membraneframework/membrane-demo/tree/master/rtp)
- [WebRTC signaling server demo](https://github.com/membraneframework/membrane-demo/tree/master/webrtc)

## Docker

The Membrane docker ([Docker Hub](https://hub.docker.com/r/membrane/membrane), [GitHub](https://github.com/membraneframework/docker-membrane)) contains Erlang, Elixir and libraries necessary to test and run the Membrane Framework.

## Media agnostic packages

| Package           | Description                                                                     | Links                                                                                                                                                                    |
| ----------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| membrane_core     | The core of the framework                                                       | [Hex](https://hex.pm/packages/membrane-core)&nbsp;[Docs](https://hexdocs.pm/membrane-core)&nbsp;[GitHub](https://github.com/membraneframework/membrane-core)             |
| membrane_common_c | Utilities for the native parts of Membrane                                      | [Hex](https://hex.pm/packages/membrane-common-c)&nbsp;[Docs](https://hexdocs.pm/membrane-common-c)&nbsp;[GitHub](https://github.com/membraneframework/membrane-common-c) |
| bundlex           | Tool for compiling C/C++ code within Mix projects                               | [Hex](https://hex.pm/packages/bundlex)&nbsp;[Docs](https://hexdocs.pm/bundlex)&nbsp;[GitHub](https://github.com/membraneframework/bundlex)                               |
| unifex            | Tool automatically generating NIF and CNode interfaces between C/C++ and Elixir | [Hex](https://hex.pm/packages/unifex)&nbsp;[Docs](https://hexdocs.pm/unifex)&nbsp;[GitHub](https://github.com/membraneframework/unifex)                                  |
| bunch             | Extension of Elixir standard library                                            | [Hex](https://hex.pm/packages/bunch)&nbsp;[Docs](https://hexdocs.pm/bunch)&nbsp;[GitHub](https://github.com/membraneframework/bunch)                                     |
| sebex             | The ultimate assistant in Membrane Framework releasing & development            | [GitHub](https://github.com/membraneframework/sebex)                                                                                                                     |

## Plugins

### Media agnostic

| Package                  | Description                                 | Links                                                                                                                                                                                         |
| ------------------------ | ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| membrane_element_file    |                                             | [Hex](https://hex.pm/packages/membrane-element-file)&nbsp;[Docs](https://hexdocs.pm/membrane-element-file)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-file)          |
| membrane_element_udp     |                                             | [Hex](https://hex.pm/packages/membrane-element-udp)&nbsp;[Docs](https://hexdocs.pm/membrane-element-udp)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-udp)             |
| membrane_element_hackney |                                             | [Hex](https://hex.pm/packages/membrane-element-hackney)&nbsp;[Docs](https://hexdocs.pm/membrane-element-hackney)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-hackney) |
| membrane_element_fake    |                                             | [Hex](https://hex.pm/packages/membrane-element-fake)&nbsp;[Docs](https://hexdocs.pm/membrane-element-fake)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-fake)          |
| membrane_scissors_plugin | Element for cutting off parts of the stream | [Hex](https://hex.pm/packages/membrane_scissors_plugin)&nbsp;[Docs](https://hexdocs.pm/membrane_scissors_plugin)&nbsp;[GitHub](https://github.com/membraneframework/membrane_scissors_plugin) |
| membrane_element_tee     |                                             | [Hex](https://hex.pm/packages/membrane-element-tee)&nbsp;[Docs](https://hexdocs.pm/membrane-element-tee)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-tee)             |
| membrane_element_pcap    | [Experimental]                              | [GitHub](https://github.com/membraneframework/membrane-element-pcap)                                                                                                                          |
| membrane_ice_plugin      | [In progress]                               | [GitHub](https://github.com/membraneframework/membrane_ice_plugin)                                                                                                                            |

### Media network protocols & containers

| Package                              | Description                                                                                      | Links                                                                                                                                                                                                                             |
| ------------------------------------ | ------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| membrane_rtp_plugin                  | [Alpha] Membrane bins and elements for handling RTP and RTCP streams                             | [Hex](https://hex.pm/packages/membrane_rtp_plugin)&nbsp;[Docs](https://hexdocs.pm/membrane_rtp_plugin)&nbsp;[GitHub](https://github.com/membraneframework/membrane_rtp_plugin)                                                    |
| membrane_bin_rtp                     | Bin consuming RTP stream. Will be deprecated when membrane_rtp_plugin goes stable.               | [Hex](https://hex.pm/packages/membrane-bin-rtp)&nbsp;[Docs](https://hexdocs.pm/membrane-bin-rtp)&nbsp;[GitHub](https://github.com/membraneframework/membrane-bin-rtp)                                                             |
| membrane_element_rtp                 | Elements for consuming RTP stream. Will be deprecated when membrane_rtp_plugin goes stable.      | [Hex](https://hex.pm/packages/membrane-element-rtp)&nbsp;[Docs](https://hexdocs.pm/membrane-element-rtp)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-rtp)                                                 |
| membrane_rtp_aac_plugin              | [Alpha] RTP AAC depayloader                                                                      | [Hex](https://hex.pm/packages/membrane_rtp_aac_plugin)&nbsp;[Docs](https://hexdocs.pm/membrane_rtp_aac_plugin)&nbsp;[GitHub](https://github.com/membraneframework/membrane_rtp_aac_plugin)                                        |
| membrane_rtp_h264_plugin             | RTP H.264 depayloader                                                                            | [Hex](https://hex.pm/packages/membrane_rtp_h264_plugin)&nbsp;[Docs](https://hexdocs.pm/membrane_rtp_h264_plugin)&nbsp;[GitHub](https://github.com/membraneframework/membrane_rtp_h264_plugin)                                     |
| membrane_rtp_mpegaudio_plugin        | Set of elements for payloading and depayloading MPEG Audio.                                      | [Hex](https://hex.pm/packages/membrane_rtp_mpegaudio_plugin)&nbsp;[Docs](https://hexdocs.pm/membrane_rtp_mpegaudio_plugin)&nbsp;[GitHub](https://github.com/membraneframework/membrane_rtp_mpegaudio_plugin)                      |
| membrane_rtp_opus_plugin             | RTP OPUS depayloader                                                                             | [Hex](https://hex.pm/packages/membrane_rtp_opus_plugin)&nbsp;[Docs](https://hexdocs.pm/membrane_rtp_opus_plugin)&nbsp;[GitHub](https://github.com/membraneframework/membrane_rtp_opus_plugin)                                     |
| membrane_mpegts_plugin               | MPEG-TS demuxer                                                                                  | [Hex](https://hex.pm/packages/membrane_mpegts_plugin)&nbsp;[Docs](https://hexdocs.pm/membrane_mpegts_plugin)&nbsp;[GitHub](https://github.com/membraneframework/membrane_mpegts_plugin)                                           |
| membrane_mp4_plugin                  | Utilities for MP4 container parsing and serialization and elements for muxing the stream to CMAF | [Hex](https://hex.pm/packages/membrane_mp4_plugin)&nbsp;[Docs](https://hexdocs.pm/membrane_mp4_plugin)&nbsp;[GitHub](https://github.com/membraneframework/membrane_mp4_plugin)                                                    |
| membrane_http_adaptive_stream_plugin | Plugin generating manifests for HTTP adaptive streaming protocols                                | [Hex](https://hex.pm/packages/membrane_http_adaptive_stream_plugin)&nbsp;[Docs](https://hexdocs.pm/membrane_http_adaptive_stream_plugin)&nbsp;[GitHub](https://github.com/membraneframework/membrane_http_adaptive_stream_plugin) |
| membrane_element_icecast             | [Experimental] Element capable of sending a stream into Icecast streaming server                 | [GitHub](https://github.com/membraneframework/membrane-element-icecast)                                                                                                                                                           |


### Audio codecs

| Package                         | Description                                         | Links                                                                                                                                                                                                              |
| ------------------------------- | --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| membrane_aac_plugin             | AAC parser and complementary elements for AAC codec | [Hex](https://hex.pm/packages/membrane_aac_plugin)&nbsp;[Docs](https://hexdocs.pm/membrane_aac_plugin)&nbsp;[GitHub](https://github.com/membraneframework/membrane_aac_plugin)                                     |
| membrane_element_fdk_aac        |                                                     | [Hex](https://hex.pm/packages/membrane-element-fdk-aac)&nbsp;[Docs](https://hexdocs.pm/membrane-element-fdk-aac)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-fdk-aac)                      |
| membrane_element_flac_parser    |                                                     | [Hex](https://hex.pm/packages/membrane-element-flac-parser)&nbsp;[Docs](https://hexdocs.pm/membrane-element-flac-parser)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-flac-parser)          |
| membrane_element_lame           |                                                     | [Hex](https://hex.pm/packages/membrane-element-lame)&nbsp;[Docs](https://hexdocs.pm/membrane-element-lame)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-lame)                               |
| membrane_element_mad            |                                                     | [Hex](https://hex.pm/packages/membrane-element-mad)&nbsp;[Docs](https://hexdocs.pm/membrane-element-mad)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-mad)                                  |
| membrane_element_mpegaudioparse |                                                     | [Hex](https://hex.pm/packages/membrane-element-mpegaudioparse)&nbsp;[Docs](https://hexdocs.pm/membrane-element-mpegaudioparse)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-mpegaudioparse) |
| membrane_opus_plugin            | OPUS decoder                                        | [Hex](https://hex.pm/packages/membrane_opus_plugin)&nbsp;[Docs](https://hexdocs.pm/membrane_opus_plugin)&nbsp;[GitHub](https://github.com/membraneframework/membrane_opus_plugin)                                  |
| membrane_element_flac_encoder   | [Suspended]                                         | [Hex](https://hex.pm/packages/membrane-element-flac-encoder)&nbsp;[Docs](https://hexdocs.pm/membrane-element-flac-encoder)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-flac-encoder)       |


### Video codecs

| Package                      | Description                                                              | Links                                                                                                                                                                                                     |
| ---------------------------- | ------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| membrane_element_ffmpeg_h264 |                                                                          | [Hex](https://hex.pm/packages/membrane-element-ffmpeg-h264)&nbsp;[Docs](https://hexdocs.pm/membrane-element-ffmpeg-h264)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-ffmpeg-h264) |
| turbojpeg                    | [Third-party] libjpeg-turbo bindings for Elixir by Binary Noggin         | [Hex](https://hex.pm/packages/turbojpeg)&nbsp;[Docs](https://hexdocs.pm/turbojpeg/readme.html)&nbsp;[GitHub](https://github.com/binarynoggin/elixir-turbojpeg)                                            |
| membrane_element_msdk_h264   | [Experimental] Hardware-accelerated H.264 encoder based on IntelMediaSDK | [GitHub](https://github.com/membraneframework/membrane-element-msdk-h264)                                                                                                                                 |


### Raw audio

| Package                            | Description    | Links                                                                                                                                                                                                                       |
| ---------------------------------- | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| membrane_element_portaudio         |                | [Hex](https://hex.pm/packages/membrane-element-portaudio)&nbsp;[Docs](https://hexdocs.pm/membrane-element-portaudio)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-portaudio)                         |
| membrane_element_ffmpeg_swresample |                | [Hex](https://hex.pm/packages/membrane-element-ffmpeg-swresample)&nbsp;[Docs](https://hexdocs.pm/membrane-element-ffmpeg-swresample)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-ffmpeg-swresample) |
| membrane_element_audiometer        |                | [Hex](https://hex.pm/packages/membrane-element-audiometer)&nbsp;[Docs](https://hexdocs.pm/membrane-element-audiometer)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-audiometer)                      |
| membrane_element_live_audiomixer   | [Experimental] | [GitHub](https://github.com/membraneframework/membrane-element-live-audiomixer)                                                                                                                                             |
| membrane_element_fade              | [Experimental] | [Hex](https://hex.pm/packages/membrane-element-fade)&nbsp;[Docs](https://hexdocs.pm/membrane-element-fade)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-fade)                                        |


### Raw video

| Package                          | Description | Links                                                                                                                                                                                                                 |
| -------------------------------- | ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| membrane_element_sdl             |             | [Hex](https://hex.pm/packages/membrane-element-sdl)&nbsp;[Docs](https://hexdocs.pm/membrane-element-sdl)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-sdl)                                     |
| membrane_element_rawvideo_parser |             | [Hex](https://hex.pm/packages/membrane-element-rawvideo-parser)&nbsp;[Docs](https://hexdocs.pm/membrane-element-rawvideo-parser)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-rawvideo-parser) |


### External APIs
| Package                                | Description | Links                                                                                                                                                                                                                                   |
| -------------------------------------- | ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| membrane_element_gcloud_speech_to_text |             | [Hex](https://hex.pm/packages/membrane-element-gcloud-speech-to-text)&nbsp;[Docs](https://hexdocs.pm/membrane-element-gcloud-speech-to-text)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-gcloud-speech-to-text) |
| membrane_element_ibm_speech_to_text    |             | [Hex](https://hex.pm/packages/membrane-element-ibm-speech-to-text)&nbsp;[Docs](https://hexdocs.pm/membrane-element-ibm-speech-to-text)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-ibm-speech-to-text)          |


## Formats

| Package                  | Description | Links                                                                                                                                                                                         |
| ------------------------ | ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| membrane_aac_format      |             | [Hex](https://hex.pm/packages/membrane_aac_format)&nbsp;[Docs](https://hexdocs.pm/membrane_aac_format)&nbsp;[GitHub](https://github.com/membraneframework/membrane_aac_format)                |
| membrane_mp4_format      |             | [Hex](https://hex.pm/packages/membrane_mp4_format)&nbsp;[Docs](https://hexdocs.pm/membrane_mp4_format)&nbsp;[GitHub](https://github.com/membraneframework/membrane_mp4_format)                |
| membrane_opus_format     |             | [Hex](https://hex.pm/packages/membrane_opus_format)&nbsp;[Docs](https://hexdocs.pm/membrane_opus_format)&nbsp;[GitHub](https://github.com/membraneframework/membrane_opus_format)             |
| membrane_rtp_format      |             | [Hex](https://hex.pm/packages/membrane_rtp_format)&nbsp;[Docs](https://hexdocs.pm/membrane_rtp_format)&nbsp;[GitHub](https://github.com/membraneframework/membrane_rtp_format)                |
| membrane_caps_audio_flac |             | [Hex](https://hex.pm/packages/membrane-caps-audio-flac)&nbsp;[Docs](https://hexdocs.pm/membrane-caps-audio-flac)&nbsp;[GitHub](https://github.com/membraneframework/membrane-caps-audio-flac) |
| membrane_caps_audio_mpeg |             | [Hex](https://hex.pm/packages/membrane-caps-audio-mpeg)&nbsp;[Docs](https://hexdocs.pm/membrane-caps-audio-mpeg)&nbsp;[GitHub](https://github.com/membraneframework/membrane-caps-audio-mpeg) |
| membrane_caps_audio_raw  |             | [Hex](https://hex.pm/packages/membrane-caps-audio-raw)&nbsp;[Docs](https://hexdocs.pm/membrane-caps-audio-raw)&nbsp;[GitHub](https://github.com/membraneframework/membrane-caps-audio-raw)    |
| membrane_caps_video_h264 |             | [Hex](https://hex.pm/packages/membrane-caps-video-h264)&nbsp;[Docs](https://hexdocs.pm/membrane-caps-video-h264)&nbsp;[GitHub](https://github.com/membraneframework/membrane-caps-video-h264) |
| membrane_caps_video_raw  |             | [Hex](https://hex.pm/packages/membrane-caps-video-raw)&nbsp;[Docs](https://hexdocs.pm/membrane-caps-video-raw)&nbsp;[GitHub](https://github.com/membraneframework/membrane-caps-video-raw)    |



## Others

| Package                   | Description    | Links                                                                                                                                                                                            |
| ------------------------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| membrane_webrtc_server    |                | [Hex](https://hex.pm/packages/membrane_webrtc_server)&nbsp;[Docs](https://hexdocs.pm/membrane_webrtc_server)&nbsp;[GitHub](https://github.com/membraneframework/webrtc-server)                   |
| membrane_protocol_sdp     |                | [Hex](https://hex.pm/packages/membrane-protocol-sdp)&nbsp;[Docs](https://hexdocs.pm/membrane-protocol-sdp)&nbsp;[GitHub](https://github.com/membraneframework/membrane-protocol-sdp)             |
| membrane_protocol_rtsp    |                | [Hex](https://hex.pm/packages/membrane-protocol-rtsp)&nbsp;[Docs](https://hexdocs.pm/membrane-protocol-rtsp)&nbsp;[GitHub](https://github.com/membraneframework/membrane-protocol-rtsp)          |
| membrane_common_audiomix  | [Experimental] | [Hex](https://hex.pm/packages/membrane-common-audiomix)&nbsp;[Docs](https://hexdocs.pm/membrane-common-audiomix)&nbsp;[GitHub](https://github.com/membraneframework/membrane-common-audiomix)    |
| membrane_protocol_icecast | [Suspended]    | [Hex](https://hex.pm/packages/membrane-protocol-icecast)&nbsp;[Docs](https://hexdocs.pm/membrane-protocol-icecast)&nbsp;[GitHub](https://github.com/membraneframework/membrane-protocol-icecast) |
| membrane_server_icecast   | [Suspended]    | [Hex](https://hex.pm/packages/membrane-server-icecast)&nbsp;[Docs](https://hexdocs.pm/membrane-server-icecast)&nbsp;[GitHub](https://github.com/membraneframework/membrane-server-icecast)       |



## Deprecated

| Package                            | Description                          | Links                                                                                                                                                                                               |
| ---------------------------------- | ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| membrane_element_rtp_jitter_buffer | Moved to membrane_rtp_plugin         | [GitHub](https://github.com/membraneframework/membrane-element-rtp-jitter-buffer)                                                                                                                   |
| membrane_element_httpoison         | Use membrane-element-hackney instead | [Hex](https://hex.pm/packages/membrane-element-httpoison)&nbsp;[Docs](https://hexdocs.pm/membrane-element-httpoison)&nbsp;[GitHub](https://github.com/membraneframework/membrane-element-httpoison) |



