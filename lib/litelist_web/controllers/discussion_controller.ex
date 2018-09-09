defmodule LitelistWeb.DiscussionController do
  use LitelistWeb, :controller

  alias Litelist.Discussions
  alias Litelist.Discussions.Discussion
  alias Litelist.Comments
  alias Litelist.Comments.Comment
  alias LitelistWeb.Utils.SharedUtils

  def index(conn, _params) do
    discussions = Discussions.list_discussions()
    render(conn, "index.html", discussions: discussions)
  end

  def new(conn, _params) do
    changeset = Discussions.change_discussion(%Discussion{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"discussion" => discussion_params}) do
    discussion_params = discussion_params
      |> SharedUtils.add_neighbor_id(conn)
      |> SharedUtils.add_slug()

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
    post = Discussions.get_discussion!(id)
    changeset = Comments.change_comment(%Comment{})
    comments = Comments.list_comments_by_discussion(post)
    render(conn, "show.html", post: post, changeset: changeset, comments: comments)
  end

  def edit(conn, %{"id" => id}) do
    discussion = Discussions.get_discussion!(id)
    changeset = Discussions.change_discussion(discussion)
    render(conn, "edit.html", discussion: discussion, changeset: changeset)
  end

  def update(conn, %{"id" => id, "discussion" => discussion_params}) do
    discussion_params = discussion_params
      |> SharedUtils.update_slug()
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

  def create_comment(conn, %{"comment" => comment_params}) do
    comment_params = comment_params
      |> SharedUtils.add_neighbor_id(conn)

    IO.inspect comment_params["discussion_id"]
    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment added successfully")
        |> redirect(to: discussion_path(conn, :show, comment_params["discussion_id"]))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:info, "Comment not added")
        |> redirect(to: discussion_path(conn, :show, comment_params["discussion_id"]))
    end
  end
end
