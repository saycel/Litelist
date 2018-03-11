defmodule LitelistWeb.JobController do
  use LitelistWeb, :controller

  alias Litelist.Posts
  alias Litelist.Posts.Post

  alias LitelistWeb.Utils.SharedUtils
  alias LitelistWeb.Utils.JobUtils

  @job_type "job"

  def index(conn, _params) do
    jobs = Posts.list_posts()
    render(conn, "index.html", jobs: jobs)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => job_params}) do
    job_params = job_params
      |> JobUtils.permitted_params()
      |> SharedUtils.add_generated_params(conn, @job_type, :create)

    case Posts.create_post(job_params) do
      {:ok, job} ->
        conn
        |> put_flash(:info, "Job created successfully.")
        |> redirect(to: job_path(conn, :show, job))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    job = Posts.get_post!(id)
    render(conn, "show.html", job: job)
  end

  def edit(conn, %{"id" => id}) do
    job = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, job) do
      changeset = Posts.change_post(job)
      render(conn, "edit.html", job: job, changeset: changeset)
    else
      unauthorized_redirect(conn)
    end
  end

  def update(conn, %{"id" => id, "job" => job_params}) do
    job = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, job) do
      case Posts.update_post(job, job_params) do
        {:ok, job} ->
          conn
          |> put_flash(:info, "Job updated successfully.")
          |> redirect(to: job_path(conn, :show, job))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", job: job, changeset: changeset)
      end
    else
      unauthorized_redirect(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    job = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, job) do
      {:ok, _job} = Posts.delete_post(job)

      conn
      |> put_flash(:info, "Job deleted successfully.")
      |> redirect(to: job_path(conn, :index))
    else
      unauthorized_redirect(conn)
    end
  end

  defp unauthorized_redirect(conn) do
    conn
    |> put_flash(:error, "Unauthorized.")
    |> redirect(to: job_path(conn, :index))
  end
end
