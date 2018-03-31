defmodule Litelist.Settings do
  @moduledoc """
  Settings using Mnesia and Amnesia wrapper.

  Sets up the %Settings table to use a row as a Singleton.
  As long as you use this API, you will only ever have one row in the DB.

  We're using the mnesia database to guarantee the availability of user-defined settings (as opposed to a separate database which may not be reachable for various reasons).
  """
  use Amnesia

  defdatabase SettingsDatabase do
    deftable Settings, [{:id, autoincrement}, :map], type: :ordered_set do
    end

    @doc """
    This is where the app generates default settings.
    Any changes to the defaults would go here.

    ## Examples

      iex> default_settings()
      %{settings}
    """
    def default_settings() do
        %{
            max_flagged_posts: 5,
            allow_replies: false
        }
    end

    @doc """
    Create default settings. If settings already exist return error.
    ## Examples
    
      iex> create_default_settings()
      {:ok}

      iex> create_default_settings()
      {:error, :already_exists}
    """
    def create_default_settings() do
        Amnesia.transaction do 
            if Settings.count() != 0 do
                {:error, :already_exists}
            else
                %Settings{map: default_settings()} |> safe_write
                {:ok}
            end
        end
    end

    @doc """
    Gets the current settings. Creates default settings if current settings don't exist.
    Returns %Settings{}
    ## Examples
    
      iex> get_settings()
      %Settings{...}
    """
    def get_settings() do
        Amnesia.transaction do
            if Settings.count() == 0 do
                create_default_settings()
            else
                Settings.first
            end
        end
    end

    @doc """
    Updates settings.
    ## Examples
    
      iex> update_settings(attrs)
      %Settings{attrs}
    """
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
