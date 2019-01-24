defmodule Litelist.SettingTest do
  use Litelist.DataCase, async: true

  alias Litelist.Factory

  describe "functionality" do
    test "Setting can be built" do
      assert Factory.insert(:settings) != nil
    end
  end
end