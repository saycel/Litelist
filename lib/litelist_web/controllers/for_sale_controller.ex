defmodule LitelistWeb.ForSaleController do
  use LitelistWeb, :controller

  alias Litelist.Posts
  alias Litelist.Posts.Post

  alias LitelistWeb.Utils.SharedUtils

  @for_sale_type "for_sale"
  @permitted_params ["contact_info", "description", "price", "slug", "title", "url"]

  def index(conn, _params) do
    for_sales = Posts.list_posts()
    render(conn, "index.html", for_sales: for_sales)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => for_sale_params}) do
    for_sale_params = for_sale_params
      |> SharedUtils.permitted_params(@permitted_params)
      |> SharedUtils.add_generated_params(conn, @for_sale_type, :create)

    case Posts.create_post(for_sale_params) do
      {:ok, for_sale} ->
        conn
        |> put_flash(:info, "For sale created successfully.")
        |> redirect(to: for_sale_path(conn, :show, for_sale))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    for_sale = Posts.get_post!(id)
    render(conn, "show.html", for_sale: for_sale)
  end

  def edit(conn, %{"id" => id}) do
    for_sale = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, for_sale) do
      changeset = Posts.change_post(for_sale)
      render(conn, "edit.html", for_sale: for_sale, changeset: changeset)
    else
      unauthorized_redirect(conn)
    end
  end

  def update(conn, %{"id" => id, "post" => for_sale_params}) do
    for_sale = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, for_sale) do
      for_sale_params = for_sale_params
        |> SharedUtils.permitted_params(@permitted_params)
        |> SharedUtils.add_generated_params(:update)

      case Posts.update_post(for_sale, for_sale_params) do
        {:ok, for_sale} ->
          conn
          |> put_flash(:info, "For sale updated successfully.")
          |> redirect(to: for_sale_path(conn, :show, for_sale))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", for_sale: for_sale, changeset: changeset)
      end
    else
      unauthorized_redirect(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    for_sale = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, for_sale) do
      {:ok, _for_sale} = Posts.delete_post(for_sale)

      conn
      |> put_flash(:info, "For sale deleted successfully.")
      |> redirect(to: for_sale_path(conn, :index))
    else
      unauthorized_redirect(conn)
    end
  end
  
  defp unauthorized_redirect(conn) do
    conn
    |> put_flash(:error, "Unauthorized.")
    |> redirect(to: for_sale_path(conn, :index))
  end
end
