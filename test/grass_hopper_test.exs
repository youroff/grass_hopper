defmodule GrassHopperTest do
  use ExUnit.Case
  doctest GrassHopper

  test "trimming timeout" do
    assert GrassHopper.trim_timeout(100) == 100
    assert GrassHopper.trim_timeout(100, min_timeout: 1000) == 1000
    assert GrassHopper.trim_timeout(100, max_timeout: 50) == 50
    assert GrassHopper.trim_timeout(:infinity) == :infinity
    assert GrassHopper.trim_timeout(:infinity, min_timeout: 1000) == :infinity
    assert GrassHopper.trim_timeout(:infinity, max_timeout: 50) == 50
  end
end
