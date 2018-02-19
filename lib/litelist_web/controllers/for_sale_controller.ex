defmodule LitelistWeb.ForSaleController do
  use LitelistWeb, :controller

  alias Litelist.Posts
  alias Litelist.Posts.ForSale
  alias Litelist.Auth.Guardian

  def index(conn, _params) do
    for_sales = Posts.list_for_sales()
    current_neighbor = Guardian.Plug.current_resource(conn)
    render(conn, "index.html", for_sales: for_sales, current_neighbor: current_neighbor)
  end

  def new(conn, _params) do
    changeset = Posts.change_for_sale(%ForSale{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"for_sale" => for_sale_params}) do
    case Posts.create_for_sale(for_sale_params) do
      {:ok, for_sale} ->
        conn
        |> put_flash(:info, "For sale created successfully.")
        |> redirect(to: for_sale_path(conn, :show, for_sale))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    for_sale = Posts.get_for_sale!(id)
    current_neighbor = Guardian.Plug.current_resource(conn)
    render(conn, "show.html", for_sale: for_sale, current_neighbor: current_neighbor)
  end

  def edit(conn, %{"id" => id}) do
    for_sale = Posts.get_for_sale!(id)
    changeset = Posts.change_for_sale(for_sale)
    render(conn, "edit.html", for_sale: for_sale, changeset: changeset)
  end

  def update(conn, %{"id" => id, "for_sale" => for_sale_params}) do
    for_sale = Posts.get_for_sale!(id)

    case Posts.update_for_sale(for_sale, for_sale_params) do
      {:ok, for_sale} ->
        conn
        |> put_flash(:info, "For sale updated successfully.")
        |> redirect(to: for_sale_path(conn, :show, for_sale))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", for_sale: for_sale, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    for_sale = Posts.get_for_sale!(id)
    {:ok, _for_sale} = Posts.delete_for_sale(for_sale)

    conn
    |> put_flash(:info, "For sale deleted successfully.")
    |> redirect(to: for_sale_path(conn, :index))
  end
end
