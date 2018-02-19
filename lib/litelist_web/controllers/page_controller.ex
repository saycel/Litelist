defmodule LitelistWeb.PageController do
  use LitelistWeb, :controller

  alias Litelist.Auth
  alias Litelist.Auth.Neighbor
  alias Litelist.Auth.Guardian

  def index(conn, _params) do
    changeset = Auth.change_neighbor(%Neighbor{})    
    message = if @current_neighbor != nil do
      "Someone is logged in"
    else
      "No one is logged in"
    end
    conn
      |> put_flash(:info, message)
      |> render("index.html", changeset: changeset, action: page_path(conn, :login))
  end
  def login(conn, %{"neighbor" => %{"username" => username, "password" => password}}) do
    # credo:disable-for-lines:2
    Auth.authenticate_neighbor(username, password)
    |> login_reply(conn)
  end
  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: "/")
  end
  defp login_reply({:ok, neighbor}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(neighbor)
    |> redirect(to: "/")
  end
  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: page_path(conn, :login))
  end
  def secret(conn, _params) do
    render(conn, "secret.html")
  end
end
