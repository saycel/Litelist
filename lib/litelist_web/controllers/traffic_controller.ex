defmodule LitelistWeb.TrafficController do
  use LitelistWeb, :controller

  alias Litelist.Posts
  alias Litelist.Posts.Post
  alias Litelist.Images.Image

  alias LitelistWeb.Utils.SharedUtils
  
  @post_type "traffic"
  @permitted_params ["description",
    "title",
    "start_date",
    "location"
  ]

  def index(conn, _params) do
    posts = Posts.list_posts_by_type(@post_type)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{
      images: [
        %Image{}
      ]
    })
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => traffic_params}) do
    traffic_params = traffic_params
      |> SharedUtils.permitted_params(@permitted_params)
      |> SharedUtils.add_generated_params(conn, @post_type, :create)
      |> SharedUtils.add_uuid_to_photo_if_exists()

    case Posts.create_post(traffic_params) do
      {:ok, traffic} ->
        conn
        |> put_flash(:info, "traffic created successfully.")
        |> redirect(to: traffic_path(conn, :show, traffic))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    if SharedUtils.match_type?(post, @post_type) do
      render(conn, "show.html", post: post)
    else
      unauthorized_redirect(conn)
    end
  end

  def edit(conn, %{"id" => id}) do
    traffic = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, traffic, @post_type) do
      changeset = Posts.change_post(traffic)
      render(conn, "edit.html", traffic: traffic, changeset: changeset)
    else
      unauthorized_redirect(conn)
    end
  end

  def update(conn, %{"id" => id, "post" => traffic_params}) do
    traffic = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, traffic, @post_type) do
      traffic_params = traffic_params
        |> SharedUtils.permitted_params(@permitted_params)
        |> SharedUtils.add_generated_params(:update)

      case Posts.update_post(traffic, traffic_params) do
        {:ok, traffic} ->
          conn
          |> put_flash(:info, "Job updated successfully.")
          |> redirect(to: traffic_path(conn, :show, traffic))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", traffic: traffic, changeset: changeset)
      end
    else
      unauthorized_redirect(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    traffic = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, traffic, @post_type) do
      {:ok, _traffic} = Posts.delete_post(traffic)

      conn
      |> put_flash(:info, "traffic deleted successfully.")
      |> redirect(to: traffic_path(conn, :index))
    else
      unauthorized_redirect(conn)
    end
  end

  defp unauthorized_redirect(conn) do
    conn
    |> put_flash(:error, "Unauthorized.")
    |> redirect(to: traffic_path(conn, :index))
  end
end
