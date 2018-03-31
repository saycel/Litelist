defmodule LitelistWeb.AdminView do
    use LitelistWeb, :view
    import LitelistWeb.UtilsView

    def get_value(settings, value) do
        Map.get(settings, value)
    end
    
end