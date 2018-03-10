defmodule LitelistWeb.ForSaleController do
  use LitelistWeb, :controller

  alias Litelist.Posts
  alias Litelist.Posts.Post

  def index(conn, _params) do
    for_sales = Posts.list_posts()
    render(conn, "index.html", for_sales: for_sales)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => for_sale_params}) do
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
    changeset = Posts.change_post(for_sale)
    render(conn, "edit.html", for_sale: for_sale, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => for_sale_params}) do
    for_sale = Posts.get_post!(id)

    case Posts.update_post(for_sale, for_sale_params) do
      {:ok, for_sale} ->
        conn
        |> put_flash(:info, "For sale updated successfully.")
        |> redirect(to: for_sale_path(conn, :show, for_sale))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", for_sale: for_sale, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    for_sale = Posts.get_post!(id)
    {:ok, _for_sale} = Posts.delete_post(for_sale)

    conn
    |> put_flash(:info, "For sale deleted successfully.")
    |> redirect(to: for_sale_path(conn, :index))
  end
end
