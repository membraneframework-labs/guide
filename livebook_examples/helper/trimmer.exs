defmodule Trimmer do
  use Membrane.Filter
  alias Membrane.Buffer

  def_options start: [
    spec: Membrane.Time.t()
  ],
  stop: [
    spec: Membrane.Time.t() | :infinity
  ]

  def_input_pad :input,
    accepted_format: _any,
    demand_mode: :auto

  def_output_pad :output,
    accepted_format: _any,
    demand_mode: :auto

  @impl true
  def handle_init(_ctx, options) do
    if options.start > options.stop do
      raise "Start time must be smaller than stop time"
    end

    state = Map.put(options, :first_pts, nil)
    {[], state}
  end

  @impl true
  def handle_process(:input, %Buffer{pts: pts}, _ctx, %{first_pts: nil} = state)
    when not is_nil(pts) do
    {[], %{state | first_pts: pts}}
  end

  @impl true
  def handle_process(:input, buffer = %Buffer{pts: pts}, _ctx, state)
    when not is_nil(pts) do
    if ignore_buffer?(buffer, state) do
      {[], state}
    else
      {[buffer: {:output, buffer}], state}
    end
  end


  defp ignore_buffer?(%Buffer{pts: pts}, state = %{stop: :infinity}) do
    %{first_pts: first_pts, start: start} = state

    pts - first_pts >= start
  end

  defp ignore_buffer?(%Buffer{pts: pts}, state) do
    %{first_pts: first_pts, start: start, stop: stop} = state

    t = pts - first_pts
    start <= t and t <= stop
  end
end
