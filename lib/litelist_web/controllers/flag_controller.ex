defmodule LitelistWeb.FlagController do
  use LitelistWeb, :controller

  alias Litelist.Moderation
  alias Litelist.Moderation.Flag
  alias Litelist.Posts
  alias LitelistWeb.Utils.SharedUtils
  alias Litelist.Settings.SettingsDatabase

  @types Flag.get_types()

  @statuses Flag.get_statuses()

  @default_status Flag.get_default_type()

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
      |> redirect(to: Routes.page_path(conn, :index))
  end

  def create(conn, %{"flag" => flag_params}) do
    flag_params = flag_params
      |> SharedUtils.parse_multi_select("type")
      |> SharedUtils.add_neighbor_id_if_exists(conn)
      |> SharedUtils.add_default_status(@default_status)

    case Moderation.create_flag(flag_params) do
      {:ok, flag} ->
        hide_post_if_over_flag_limit(flag)
        conn
        |> put_flash(:info, "Flag created successfully.")
        |> redirect(to: Routes.flag_path(conn, :show, flag))
      {:error, %Ecto.Changeset{} = changeset} ->
        post = Posts.get_post!(changeset.changes.post_id)

        render(conn, "new.html", changeset: changeset, post: post, types: @types)
    end
  end

  def show(conn, %{"id" => id}) do
    flag = Moderation.get_flag!(id)
    render(conn, "show.html", flag: flag)
  end

  def edit(conn, %{"id" => id}) do
    flag = Moderation.get_flag!(id)
    post = Posts.get_post!(flag.post_id)

    changeset = Moderation.change_flag(flag)
    render(conn, "edit.html", flag: flag, changeset: changeset, post: post, statuses: @statuses)
  end

  def update(conn, %{"id" => id, "flag" => flag_params}) do
    flag = Moderation.get_flag!(id)

    case Moderation.update_flag(flag, flag_params) do
      {:ok, flag} ->
        restore_post_if_flags_cleared(flag)
        conn
        |> put_flash(:info, "Flag updated successfully.")
        |> redirect(to: Routes.flag_path(conn, :show, flag))
      {:error, %Ecto.Changeset{} = changeset} ->
        post = Posts.get_post!(flag.post_id)
        render(conn, "edit.html", flag: flag, changeset: changeset, post: post, statuses: @statuses)
    end
  end

  def delete(conn, %{"id" => id}) do
    flag = Moderation.get_flag!(id)
    {:ok, _flag} = Moderation.delete_flag(flag)
    restore_post_if_flags_cleared(flag)
    conn
    |> put_flash(:info, "Flag deleted successfully.")
    |> redirect(to: Routes.flag_path(conn, :index))
  end

  def guidelines(conn, _) do
    conn
      |> render("guidelines.html")
  end

  defp hide_post_if_over_flag_limit(flag) do
    post = Posts.get_post!(flag.post_id)
    settings = SettingsDatabase.get_settings().map
    Posts.hide_post_if_over_flag_limit(post, settings.max_flagged_posts)
  end

  defp restore_post_if_flags_cleared(flag) do
    post = Posts.get_post!(flag.post_id)
    Posts.restore_post_if_flags_cleared(post)
  end
end
