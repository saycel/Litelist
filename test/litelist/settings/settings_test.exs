defmodule Litelist.SettingsTest do
    use Litelist.DataCase
    use Amnesia

    alias Litelist.Settings.SettingsDatabase

    describe "SettingsDatabase" do
        test "get_settings/0 returns a Map with keys" do
            return_value = SettingsDatabase.get_settings()
            assert Map.keys(return_value) > 0
        end

        test "update_settings/1 updates settings with the parameter" do
            setting_1_value = "one"
            setting_2_value = false
            setting_3_value = 1
            attr = %{
                setting_1: setting_1_value,
                setting_2: setting_2_value,
                setting_3: setting_3_value
            }

            # Make sure db is set up
            SettingsDatabase.get_settings()

            return_value = SettingsDatabase.update_settings(attr)
            updated_settings = SettingsDatabase.get_settings()

            setting_1_return_value =  Map.get(updated_settings, :map).setting_1
            setting_2_return_value =  Map.get(updated_settings, :map).setting_2
            setting_3_return_value =  Map.get(updated_settings, :map).setting_3

            assert return_value == {:ok}
            assert setting_1_value == setting_1_return_value
            assert setting_2_value == setting_2_return_value
            assert setting_3_value == setting_3_return_value
        end

        test "there will only be one settings row in the db regardless of how many reads and writes are made" do
            setting_1_value = "one"
            setting_2_value = false
            attr = %{
                setting_1: setting_1_value,
                setting_2: setting_2_value
            }

            SettingsDatabase.get_settings()
            SettingsDatabase.get_settings()
            SettingsDatabase.get_settings()
            SettingsDatabase.get_settings()
            SettingsDatabase.get_settings()

            SettingsDatabase.update_settings(attr)
            SettingsDatabase.update_settings(attr)
            SettingsDatabase.update_settings(attr)
            SettingsDatabase.update_settings(attr)
            SettingsDatabase.update_settings(attr)

            SettingsDatabase.get_settings()
            SettingsDatabase.get_settings()
            SettingsDatabase.get_settings()
            SettingsDatabase.get_settings()
            SettingsDatabase.get_settings()

            SettingsDatabase.update_settings(attr)
            SettingsDatabase.update_settings(attr)
            SettingsDatabase.update_settings(attr)
            SettingsDatabase.update_settings(attr)
            SettingsDatabase.update_settings(attr)

            Amnesia.transaction do
                assert SettingsDatabase.Settings.count == 1
            end
        end
    end
end
