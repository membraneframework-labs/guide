# After running this script, you can access the server at rtmp://localhost:1935
# You can use FFmpeg to stream to it
# ffmpeg -re -i test/fixtures/testsrc.flv -f flv -c:v copy -c:a copy rtmp://localhost:1935

Mix.install([
  :membrane_aac_plugin,
  :membrane_mp4_plugin,
  :membrane_flv_plugin,
  :membrane_file_plugin,
  :membrane_rtmp_plugin
])

defmodule Pipeline do
  use Membrane.Pipeline

  @output_file "received.flv"

  @impl true
  def handle_init(_ctx, socket: socket) do
    structure = [
      child(:source, %Membrane.RTMP.SourceBin{
        socket: socket
      }),
      child(:video_payloader, Membrane.MP4.Payloader.H264),
      child(:muxer, Membrane.FLV.Muxer),
      child(:sink, %Membrane.File.Sink{location: @output_file}),
      get_child(:source) |> via_out(:audio) |> via_in(Pad.ref(:audio, 0)) |> get_child(:muxer),
      get_child(:source)
      |> via_out(:video)
      |> get_child(:video_payloader)
      |> via_in(Pad.ref(:video, 0))
      |> get_child(:muxer),
      get_child(:muxer) |> get_child(:sink)
    ]

    {[spec: structure, playback: :playing], %{}}
  end

  # Once the source initializes, we grant it the control over the tcp socket
  @impl true
  def handle_child_notification(
        {:socket_control_needed, _socket, _source} = notification,
        :source,
        _ctx,
        state
      ) do
    send(self(), notification)

    {[], state}
  end

  def handle_child_notification(_notification, _child, _ctx, state) do
    {[], state}
  end

  @impl true
  def handle_info({:socket_control_needed, socket, source} = notification, _ctx, state) do
    case Membrane.RTMP.SourceBin.pass_control(socket, source) do
      :ok ->
        :ok

      {:error, :not_owner} ->
        Process.send_after(self(), notification, 200)
    end

    {[], state}
  end

  # The rest of the module is used for self-termination of the pipeline after processing finishes
  @impl true
  def handle_element_end_of_stream(:sink, _pad, _ctx, state) do
    {[terminate: :shutdown], state}
  end

  @impl true
  def handle_element_end_of_stream(_child, _pad, _ctx, state) do
    {[], state}
  end
end

defmodule Example do
  @server_ip {127, 0, 0, 1}
  @server_port 1935

  def run() do
    parent = self()

    server_options = %Membrane.RTMP.Source.TcpServer{
      port: @server_port,
      listen_options: [
        :binary,
        packet: :raw,
        active: false,
        ip: @server_ip
      ],
      socket_handler: fn socket ->
        # On new connection a pipeline is started
        {:ok, _supervisor, pipeline} = Pipeline.start_link(socket: socket)
        send(parent, {:pipeline_spawned, pipeline})
        {:ok, pipeline}
      end
    }

    Membrane.RTMP.Source.TcpServer.start_link(server_options)

    pipeline =
      receive do
        {:pipeline_spawned, pid} ->
          pid
      end

    ref = Process.monitor(pipeline)

    receive do
      {:DOWN, ^ref, :process, _obj, _reason} ->
        :ok
    end
  end
end

Example.run()
