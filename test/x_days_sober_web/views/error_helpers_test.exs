defmodule XDaysSoberWeb.ErrorHelpersTest do
  use ExUnit.Case, async: true

  alias XDaysSoberWeb.ErrorHelpers

  describe "translate_error/2" do
    test "translates a standard error message" do
      assert ErrorHelpers.translate_error({"is invalid", []}) == "is invalid"
    end

    test "translates a error message with a count" do
      assert ErrorHelpers.translate_error({"%{count} files", count: 2}) == "2 files"
    end
  end
end
