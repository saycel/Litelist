defmodule LitelistWeb.DiscussionController do
  use LitelistWeb, :controller

  alias Litelist.Discussions
  alias Litelist.Discussions.Discussion

  alias LitelistWeb.Utils.SharedUtils

  @permitted_params ["title", "description"]

  def index(conn, _params) do
    discussions = Discussions.list_discussions()
    render(conn, "index.html", discussions: discussions)
  end

  def new(conn, _params) do
    changeset = Discussions.change_discussion(%Discussion{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => discussion_params}) do
    discussion_params = discussion_params
      |> SharedUtils.permitted_params(@permitted_params)
      |> SharedUtils.add_generated_params(conn, :create)

    case Discussions.create_discussion(discussion_params) do
      {:ok, discussion} ->
        conn
        |> put_flash(:info, "Discussion created successfully.")
        |> redirect(to: discussion_path(conn, :show, discussion))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    discussion = Discussions.get_discussion!(id)
    render(conn, "show.html", discussion: discussion)
  end

  def edit(conn, %{"id" => id}) do
    if SharedUtils.admin?(conn.assigns.current_neighbor) do
      discussion = Discussions.get_discussion!(id)
      changeset = Discussions.change_discussion(discussion)
      render(conn, "edit.html", discussion: discussion, changeset: changeset)
    else
      unauthorized_redirect(conn)
    end
  end

  def update(conn, %{"id" => id, "post" => discussion_params}) do
    if SharedUtils.admin?(conn.assigns.current_neighbor) do
      discussion_params = discussion_params
        |> SharedUtils.permitted_params(@permitted_params)
        |> SharedUtils.add_generated_params(:update)
      discussion = Discussions.get_discussion!(id)

      case Discussions.update_discussion(discussion, discussion_params) do
        {:ok, discussion} ->
          conn
          |> put_flash(:info, "Discussion updated successfully.")
          |> redirect(to: discussion_path(conn, :show, discussion))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", discussion: discussion, changeset: changeset)
      end
    else
      unauthorized_redirect(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    discussion = Discussions.get_discussion!(id)
    {:ok, _discussion} = Discussions.delete_discussion(discussion)

    conn
    |> put_flash(:info, "Discussion deleted successfully.")
    |> redirect(to: discussion_path(conn, :index))
  end

  defp unauthorized_redirect(conn) do
    conn
    |> put_flash(:error, "Unauthorized.")
    |> redirect(to: discussion_path(conn, :index))
  end
end
