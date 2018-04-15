defmodule LitelistWeb.EventController do
  use LitelistWeb, :controller

  alias Litelist.Posts
  alias Litelist.Posts.Post
  alias Litelist.Images.Image

  alias LitelistWeb.Utils.SharedUtils

  @post_type "event"
  @permitted_params ["contact_info",
    "description",
    "title",
    "url",
    "start_time",
    "end_time",
    "location"
  ]

  def index(conn, _params) do
    events = Posts.list_posts_by_type(@post_type)
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{
      images: [
        %Image{}
      ]
    })
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => event_params}) do
    event_params = event_params
      |> SharedUtils.permitted_params(@permitted_params)
      |> SharedUtils.add_generated_params(conn, @post_type, :create)

    case Posts.create_post(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Posts.get_post!(id)
    if SharedUtils.match_type?(event, @post_type) do
      render(conn, "show.html", event: event)
    else
      unauthorized_redirect(conn)
    end
  end

  def edit(conn, %{"id" => id}) do
    event = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, event, @post_type) do
      changeset = Posts.change_post(event)
      render(conn, "edit.html", event: event, changeset: changeset)
    else
      unauthorized_redirect(conn)
    end
  end

  def update(conn, %{"id" => id, "post" => event_params}) do
    event = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, event, @post_type) do

      event_params = event_params
        |> SharedUtils.permitted_params(@permitted_params)
        |> SharedUtils.add_generated_params(:update)

      case Posts.update_post(event, event_params) do
        {:ok, event} ->
          conn
          |> put_flash(:info, "Event updated successfully.")
          |> redirect(to: event_path(conn, :show, event))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", event: event, changeset: changeset)
      end
    else
      unauthorized_redirect(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, event, @post_type) do
      {:ok, _event} = Posts.delete_post(event)

      conn
      |> put_flash(:info, "Event deleted successfully.")
      |> redirect(to: event_path(conn, :index))
    else
      unauthorized_redirect(conn)
    end
  end

  defp unauthorized_redirect(conn) do
    conn
    |> put_flash(:error, "Unauthorized.")
    |> redirect(to: event_path(conn, :index))
  end
end
