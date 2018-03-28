defmodule LitelistWeb.PageController do
  use LitelistWeb, :controller

  alias Litelist.Auth
  alias Litelist.Auth.Neighbor
  alias Litelist.Auth.Guardian
  alias Litelist.Posts

  def index(conn, _params) do
    posts = Posts.list_posts
    conn
      |> render("index.html", posts: posts)
  end

  def information(conn, _params) do
    conn
      |> render("post2list.html")
  end

  def login(conn, _params) do
    changeset = Auth.change_neighbor(%Neighbor{})
    if conn.assigns.current_neighbor do
      conn
      |> put_flash(:info, "Already logged in #{conn.assigns.current_neighbor.username}")
      |> redirect(to: "/")
    else
      conn
      |> render("login.html", changeset: changeset, action: page_path(conn, :index))
    end
  end

  def post_login(conn, %{"neighbor" => %{"username" => username, "password" => password}}) do
    # credo:disable-for-lines:2
    IO.inspect("**********")
    Auth.authenticate_neighbor(username, password)
    |> login_reply(conn)
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: page_path(conn, :login))
  end

  defp login_reply({:ok, neighbor}, conn) do
    conn
    |> Guardian.Plug.sign_in(neighbor)
    |> redirect(to: page_path(conn, :index))
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end

  def secret(conn, _params) do
    render(conn, "secret.html")
  end
end
