defmodule Membrane.Custom.Filter do
  use Membrane.Filter
  def_input_pad :input,
    accepted_format: _any,
    demand_mode: :auto

  def_output_pad :output,
    accepted_format: _any,
    demand_mode: :auto

  def_options handle_end_of_stream: [
    spec: (
      pad :: Membrane.Pad.ref_t(),
      context :: Membrane.Element.CallbackContext.StreamManagement.t(),
      state :: Membrane.Element.state_t()
      -> Membrane.Element.Base.callback_return_t()),
    default: &__MODULE__.handle_end_of_stream_def/3
  ]

  def handle_end_of_stream_def(_pad, _ctx, state) do
    {[{:end_of_stream, :output}], state}
  end

  @impl true
  def handle_end_of_stream(pad, ctx, state) do
    %{handle_end_of_stream: handle_end_of_stream} = state
    handle_end_of_stream.(pad, ctx, state)
  end

  @impl true
  def handle_process(:input, buffer, _ctx, state) do
    {[buffer: {:output, buffer}], state}
  end


  @impl true
  def handle_init(_ctx, options) do
    {[], options}
  end
end
