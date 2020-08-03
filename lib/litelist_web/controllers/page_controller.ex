defmodule LitelistWeb.PageController do
  use LitelistWeb, :controller
  alias Litelist.Auth
  alias Litelist.Auth.Neighbor
  alias Litelist.Auth.Guardian
  alias Litelist.Posts
  alias Litelist.Settings.SettingsDatabase
  alias Litelist.Settings


  def index(conn, _params) do
    posts = Posts.list_ordered_by_updated_at()
    conn
    |> render("index.html", posts: posts)
  end

  def information(conn, _params) do
    conn
    |> render("post2list.html")
  end

  def url_handler(conn, _params) do
    host = get_host(conn)
    name =  Settings.get_settings().name
    if host == name do
      posts = Posts.list_ordered_by_updated_at()
      conn
      |> render("index.html", posts: posts)
    else
      post = Posts.get_post_by_url(host)
      if post do
        conn
        |> render(
          "display.html",
          post: Enum.at(post, 0),
          layout: {LitelistWeb.LayoutView, "webpage.html"}
        )
      else
        conn
        |> put_flash(:info, "webpage does not exist")
        |> redirect(to: Routes.page_path(conn, :index))
      end
    end
  end

  def login(conn, _params) do
    changeset = Auth.change_neighbor(%Neighbor{})

    if conn.assigns.current_neighbor do
      conn
      |> put_flash(:info, "Already logged in #{conn.assigns.current_neighbor.username}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> render("login.html", changeset: changeset, action: Routes.page_path(conn, :post_login))
    end
  end

  def signUp(conn, _params) do
    changeset = Auth.change_neighbor(%Neighbor{})

    if conn.assigns.current_neighbor do
      conn
      |> put_flash(:info, "Already logged in #{conn.assigns.current_neighbor.username}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> render("signUp.html", changeset: changeset, action: Routes.page_path(conn, :post_login))
    end
  end

  def post_login(conn, %{
        "neighbor" => %{
          "username" => username,
          "password" => password,
          "create_neighbor" => _create_neighbor,
          "first_name" => first_name,
          "last_name" => last_name
        }
      }) do
    Auth.create_neighbor(%{
      username: username,
      password: password,
      first_name: first_name,
      last_name: last_name
    })

    # credo:disable-for-lines:2
    Auth.authenticate_neighbor(username, password)
    |> login_reply(conn)
  end

  def post_login(conn, %{"neighbor" => %{"username" => username, "password" => password}}) do
    # credo:disable-for-lines:2
    Auth.authenticate_neighbor(username, password)
    |> login_reply(conn)
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: Routes.page_path(conn, :login))
  end

  defp login_reply({:ok, neighbor}, conn) do
    conn
    |> Guardian.Plug.sign_in(neighbor)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Logged out")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp get_host(conn) do
    url =
      Atom.to_string(conn.scheme) <>
        "://" <> (conn.req_headers |> Enum.into(%{}) |> Map.get("host")) <> conn.request_path

    substring_w_http = String.split(url, ".othernet")
    http_host = String.split(Enum.at(substring_w_http, 0), "http://")
    host = Enum.at(http_host, 1)
    host
  end
end
