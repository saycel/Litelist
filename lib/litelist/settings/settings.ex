defmodule Litelist.Settings do
  @moduledoc """
  Settings using Mnesia and Amnesia wrapper
  """
  use Amnesia

  defdatabase SettingsDatabase do
    deftable Settings, [{:id, autoincrement}, :map], type: :ordered_set do
    end

    def default_settings() do
        %{
            max_flagged_posts: 5,
            allow_replies: false
        }
    end

    def create_default_settings() do
        Amnesia.transaction do 
            if Settings.count() != 0 do
                {:error, :already_exists}
            else
                %Settings{map: default_settings()} |> safe_write
            end
        end
    end

    def get_settings() do
        Amnesia.transaction do
            if Settings.count() == 0 do
                create_default_settings()
            else
                Settings.first
            end
        end
    end

    def update_settings(attrs) do
        Amnesia.transaction do
            settings = Settings.read(Settings.first.id)
            new_settings = Map.merge(%{map: attrs}, Map.delete(settings, :map))
            new_settings |> Settings.write
        end
    end

    defp safe_write(attrs) do
        Amnesia.transaction do
            if Settings.count() != 0 do
                {:error, :already_exists}
            else
                attrs |> Settings.write
            end
        end
    end
  end
end
