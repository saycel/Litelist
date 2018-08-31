defmodule LitelistWeb.JobController do
  use LitelistWeb, :controller

  alias Litelist.Posts
  alias Litelist.Posts.Post
  alias Litelist.Images.Image

  alias LitelistWeb.Utils.SharedUtils
  
  @post_type "job"
  @permitted_params ["contact_info",
    "description",
    "salary",
    "title",
    "url",
    "start_date",
    "end_date",
    "company_name",
    "position_name",
    "location"
  ]

  def index(conn, _params) do
    jobs = Posts.list_posts_by_type(@post_type)
    render(conn, "index.html", jobs: jobs)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{
      images: [
        %Image{}
      ]
    })
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => job_params}) do
    job_params = job_params
      |> SharedUtils.permitted_params(@permitted_params)
      |> SharedUtils.add_generated_params(conn, @post_type, :create)
      |> SharedUtils.add_uuid_to_photo_if_exists()

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
    post = Posts.get_post!(id)
    if SharedUtils.match_type?(post, @post_type) do
      render(conn, "show.html", post: post)
    else
      unauthorized_redirect(conn)
    end
  end

  def edit(conn, %{"id" => id}) do
    job = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, job, @post_type) do
      changeset = Posts.change_post(job)
      render(conn, "edit.html", job: job, changeset: changeset)
    else
      unauthorized_redirect(conn)
    end
  end

  def update(conn, %{"id" => id, "post" => job_params}) do
    job = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, job, @post_type) do
      job_params = job_params
        |> SharedUtils.permitted_params(@permitted_params)
        |> SharedUtils.add_generated_params(:update)

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
    if SharedUtils.permission?(conn.assigns.current_neighbor, job, @post_type) do
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
