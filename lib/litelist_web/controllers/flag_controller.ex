defmodule LitelistWeb.FlagController do
  use LitelistWeb, :controller

  alias Litelist.Moderation
  alias Litelist.Moderation.Flag
  alias Litelist.Posts
  alias LitelistWeb.Utils.SharedUtils

  @permitted_params [
    "post_id",
    "neighbor_id",
    "type",
    "description",
    "status",
    "admin_respons"
  ]

  @types [
    "Inappropriate",
    "Incorrect information",
    "Legal concerns",
    "Abusive"
  ]

  @default_status "pending"

  def index(conn, _params) do
    flags = Moderation.list_flags()
    render(conn, "index.html", flags: flags)
  end

  def new(conn, %{"post_id" => post_id}) do
    post = Posts.get_post!(post_id)

    changeset = Moderation.change_flag(%Flag{})
    render(conn, "new.html", changeset: changeset, post: post, types: @types)
  end

  def new(conn, _params) do
    conn
      |> put_flash(:info, "To add a flag, go to a post and click on a 'flag' button.")
      |> redirect(to: page_path(conn, :index))
  end

  def create(conn, %{"flag" => flag_params}) do
    IO.inspect flag_params
    flag_params = flag_params
      |> SharedUtils.permitted_params(@permitted_params)
      |> SharedUtils.parse_multi_select("type")
      |> SharedUtils.add_neighbor_id(conn)
      |> SharedUtils.add_default_status(@default_status)

    IO.inspect flag_params
    case Moderation.create_flag(flag_params) do
      {:ok, flag} ->
        conn
        |> put_flash(:info, "Flag created successfully.")
        |> redirect(to: flag_path(conn, :show, flag))
      {:error, %Ecto.Changeset{} = changeset} ->
        post = Posts.get_post!(2)

        render(conn, "new.html", changeset: changeset, post: post, types: @types)
    end
  end

  def show(conn, %{"id" => id}) do
    flag = Moderation.get_flag!(id)
    render(conn, "show.html", flag: flag)
  end

  def edit(conn, %{"id" => id}) do
    flag = Moderation.get_flag!(id)
    changeset = Moderation.change_flag(flag)
    render(conn, "edit.html", flag: flag, changeset: changeset)
  end

  def update(conn, %{"id" => id, "flag" => flag_params}) do
    flag = Moderation.get_flag!(id)

    case Moderation.update_flag(flag, flag_params) do
      {:ok, flag} ->
        conn
        |> put_flash(:info, "Flag updated successfully.")
        |> redirect(to: flag_path(conn, :show, flag))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", flag: flag, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    flag = Moderation.get_flag!(id)
    {:ok, _flag} = Moderation.delete_flag(flag)

    conn
    |> put_flash(:info, "Flag deleted successfully.")
    |> redirect(to: flag_path(conn, :index))
  end
end
