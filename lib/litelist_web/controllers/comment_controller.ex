defmodule LitelistWeb.CommentController do
    use LitelistWeb, :controller
  
    alias Litelist.Discussions
    alias Litelist.Discussions.Discussion
    alias Litelist.Discussions.Comment
  
    alias LitelistWeb.Utils.SharedUtils
  

  
    def create(conn, %{"comment" => comment_params}) do
      comment_params = comment_params
        |> SharedUtils.add_neighbor_id(conn)
      discussion_id = comment_params["discussion_id"]
      case Discussions.create_comment(comment_params) do
        {:ok, comment} ->
          conn
          |> put_flash(:info, "Comment added.")
          |> redirect(to: discussion_path(conn, :show, discussion_id))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  
  
    def delete(conn, %{"id" => id}) do
      comment = Discussions.get_comment!!(id)
      discussion_id = comment.discussion_id
      {:ok, _comment} = Discussions.delete_comment(comment)
  
      conn
      |> put_flash(:info, "Comment deleted successfully.")
      |> redirect(to: discussion_path(conn, :show, discussion_id))
    end
  end
  