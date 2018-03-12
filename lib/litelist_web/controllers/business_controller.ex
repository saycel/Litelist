defmodule LitelistWeb.BusinessController do
  use LitelistWeb, :controller

  alias Litelist.Posts
  alias Litelist.Posts.Business

  def index(conn, _params) do
    businesses = Posts.list_businesses()
    render(conn, "index.html", businesses: businesses)
  end

  def new(conn, _params) do
    changeset = Posts.change_business(%Business{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"business" => business_params}) do
    case Posts.create_business(business_params) do
      {:ok, business} ->
        conn
        |> put_flash(:info, "Business created successfully.")
        |> redirect(to: business_path(conn, :show, business))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    business = Posts.get_business!(id)
    render(conn, "show.html", business: business)
  end

  def edit(conn, %{"id" => id}) do
    business = Posts.get_business!(id)
    changeset = Posts.change_business(business)
    render(conn, "edit.html", business: business, changeset: changeset)
  end

  def update(conn, %{"id" => id, "business" => business_params}) do
    business = Posts.get_business!(id)

    case Posts.update_business(business, business_params) do
      {:ok, business} ->
        conn
        |> put_flash(:info, "Business updated successfully.")
        |> redirect(to: business_path(conn, :show, business))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", business: business, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    business = Posts.get_business!(id)
    {:ok, _business} = Posts.delete_business(business)

    conn
    |> put_flash(:info, "Business deleted successfully.")
    |> redirect(to: business_path(conn, :index))
  end
end
