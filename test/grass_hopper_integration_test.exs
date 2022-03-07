defmodule GrassHopperIntegrationTest do
  use ExUnit.Case
  # import Mock

  defmodule Implementation do
    use GrassHopper, max_timeout: 1000, min_timeout: 50

    @impl true
    def next(_), do: throw("Next callback must be stubbed")

    @impl true
    def perform(_), do: throw("Perfrom callback must be stubbed")
  end

  # test "it runs" do
  #   GrassHopper.start_link(Implementation, min_timeout: 100)
  # end

  # TODO: Figure out the way to mock callbacks dynamically

  # test "next: infinity and no max_timeout cap" do
  #   with_mock mod, [:passthrough], [next: fn _ -> nil end] do
  #     state = default_state()
  #     assert {_, ^state} = Implementation.handle_continue(nil, state)
  #   end
  # end

  # test "next: infinity and max_timeout" do
  #   state = %{default_state() | opts: [max_timeout: 100]}
  #   assert {_, ^state} = Implementation.handle_continue(nil, state)
  # end

  def default_state() do
    now = NaiveDateTime.utc_now()
    %{from: now, to: now, opts: []}
  end
end
