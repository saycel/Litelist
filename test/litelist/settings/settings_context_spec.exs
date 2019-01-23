defmodule Litelist.SettingsSpec do
  use Litelist.DataCase, async: true

  alias Litelist.Settings
  alias Litelist.Settings.Settings
  alias Litelist.Factory

  describe "settings" do
    @valid_attrs %{
      name: "some name",
      max_flagged_posts: 5,
      allow_replies: false
    }

    @invalid_attrs %{
      name: nil,
      max_flagged_posts: nil,
      allow_replies: nil
    }

    test "get_settings/0 returns last settings" do
      Factory.insert(:settings)
      Factory.insert(:settings)
      expected_settings = Factory.insert(:settings, @valid_attrs)
      assert Settings.get_settings() == expected_settings
    end

    test "get_settings/0 returns default settings if no settings exist" do
      assert Settings.get_settings() != nil
    end

    test "new_settings/1 creates a new settings row" do
      assert {:ok, %Settings{} = settings} = Settings.new_settings(@valid_attrs)
    end
  end
end