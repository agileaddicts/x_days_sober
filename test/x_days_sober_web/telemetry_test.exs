defmodule XDaysSoberWeb.TelemetryTest do
  use ExUnit.Case, async: true

  alias XDaysSoberWeb.Telemetry

  test "successful metrics call" do
    assert length(Telemetry.metrics()) > 0
  end
end
