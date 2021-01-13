defmodule Litelist.Auth.ErrorHandler do
  @moduledoc """
  Handles authentication errors
  """
  import Plug.Conn
  use LitelistWeb, :controller

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> redirect(to: Routes.page_path(conn, :login))

  end
end
