defmodule Litelist.Auth.ErrorHandler do
  @moduledoc """
  Handles authentication errors
  """
  import Plug.Conn
  def auth_error(conn, {type, _reason}, _opts) do
    body = "Please Login to Continue"
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, body)
  end
end
