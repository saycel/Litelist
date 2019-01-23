defmodule Litelist.SettingTest do
  use Litelist.DataCase, async: true

  alias Litelist.Settings.Settings
  alias Litelist.Repo
  alias Litelist.Factory

  describe "functionality" do
    test "Setting can be built" do
      setting = Factory.insert(:settings)
    end
  end
end