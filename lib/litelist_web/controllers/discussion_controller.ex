defmodule LitelistWeb.DiscussionController do
  use LitelistWeb, :controller

  alias Litelist.Discussions
  alias Litelist.Discussions.Discussion

  def index(conn, _params) do
    discussions = Discussions.list_discussions()
    render(conn, "index.html", discussions: discussions)
  end

  def new(conn, _params) do
    changeset = Discussions.change_discussion(%Discussion{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"discussion" => discussion_params}) do
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
    discussion = Discussions.get_discussion!(id)
    changeset = Discussions.change_discussion(discussion)
    render(conn, "edit.html", discussion: discussion, changeset: changeset)
  end

  def update(conn, %{"id" => id, "discussion" => discussion_params}) do
    discussion = Discussions.get_discussion!(id)

    case Discussions.update_discussion(discussion, discussion_params) do
      {:ok, discussion} ->
        conn
        |> put_flash(:info, "Discussion updated successfully.")
        |> redirect(to: discussion_path(conn, :show, discussion))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", discussion: discussion, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    discussion = Discussions.get_discussion!(id)
    {:ok, _discussion} = Discussions.delete_discussion(discussion)

    conn
    |> put_flash(:info, "Discussion deleted successfully.")
    |> redirect(to: discussion_path(conn, :index))
  end
end
