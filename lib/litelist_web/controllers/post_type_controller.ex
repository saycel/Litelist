defmodule LitelistWeb.PostTypeController do
  use LitelistWeb, :controller

  alias Litelist.Posts
  alias Litelist.Posts.PostType

  def new(conn, _params) do
    changeset = Posts.change_post_type(%PostType{})
    render(conn, "new.html", changeset: changeset)
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"post_type" => post_type_params}) do
    IO.inspect("Post type params")
    IO.inspect(post_type_params)
  end

  # def edit(conn, %{"id" => id}) do
  #   job = Posts.get_post!(id)
  #   if SharedUtils.permission?(conn.assigns.current_neighbor, job, @post_type) do
  #     changeset = Posts.change_post(job)
  #     render(conn, "edit.html", job: job, changeset: changeset)
  #   else
  #     unauthorized_redirect(conn)
  #   end
  # end

  # def update(conn, %{"id" => id, "post" => job_params}) do
  #   job = Posts.get_post!(id)
  #   if SharedUtils.permission?(conn.assigns.current_neighbor, job, @post_type) do
  #     job_params = job_params
  #       |> SharedUtils.permitted_params(@permitted_params)
  #       |> SharedUtils.add_generated_params(:update)

  #     case Posts.update_post(job, job_params) do
  #       {:ok, job} ->
  #         conn
  #         |> put_flash(:info, "Job updated successfully.")
  #         |> redirect(to: Routes.job_path(conn, :show, job))
  #       {:error, %Ecto.Changeset{} = changeset} ->
  #         render(conn, "edit.html", job: job, changeset: changeset)
  #     end
  #   else
  #     unauthorized_redirect(conn)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   job = Posts.get_post!(id)
  #   if SharedUtils.permission?(conn.assigns.current_neighbor, job, @post_type) do
  #     {:ok, _job} = Posts.delete_post(job)

  #     conn
  #     |> put_flash(:info, "Job deleted successfully.")
  #     |> redirect(to: Routes.job_path(conn, :index))
  #   else
  #     unauthorized_redirect(conn)
  #   end
  # end

  # defp unauthorized_redirect(conn) do
  #   conn
  #   |> put_flash(:error, "Unauthorized.")
  #   |> redirect(to: Routes.job_path(conn, :index))
  # end
end
