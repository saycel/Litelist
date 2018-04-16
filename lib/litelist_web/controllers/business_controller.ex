defmodule LitelistWeb.BusinessController do
  use LitelistWeb, :controller

  alias Litelist.Posts
  alias Litelist.Posts.Post
  alias Litelist.Images.Image

  alias LitelistWeb.Utils.SharedUtils

  alias LitelistWeb.Utils.SharedUtils

  @post_type "business"
  @permitted_params ["contact_info",
    "description",
    "title",
    "url",
    "location"
  ]

  def index(conn, _params) do
    businesses = Posts.list_posts_by_type(@post_type)
    render(conn, "index.html", businesses: businesses)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{
      images: [
        %Image{}
      ]
    })
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => business_params}) do
    business_params = business_params
      |> SharedUtils.permitted_params(@permitted_params)
      |> SharedUtils.add_generated_params(conn, @post_type, :create)

    case Posts.create_post(business_params) do
      {:ok, business} ->
        conn
        |> put_flash(:info, "Business created successfully.")
        |> redirect(to: business_path(conn, :show, business))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    business = Posts.get_post!(id)
    if SharedUtils.match_type?(business, @post_type) do
      render(conn, "show.html", business: business)
    else
      unauthorized_redirect(conn)
    end
  end

  def edit(conn, %{"id" => id}) do
    business = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, business, @post_type) do
      changeset = Posts.change_post(business)
      render(conn, "edit.html", business: business, changeset: changeset)
    else
      unauthorized_redirect(conn)
    end
  end

  def update(conn, %{"id" => id, "post" => business_params}) do
    business = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, business, @post_type) do
      business_params = business_params
        |> SharedUtils.permitted_params(@permitted_params)
        |> SharedUtils.add_generated_params(:update)
      case Posts.update_post(business, business_params) do
        {:ok, business} ->
          conn
          |> put_flash(:info, "Business updated successfully.")
          |> redirect(to: business_path(conn, :show, business))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", business: business, changeset: changeset)
      end
    else
      unauthorized_redirect(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    business = Posts.get_post!(id)
    if SharedUtils.permission?(conn.assigns.current_neighbor, business, @post_type) do
      {:ok, _business} = Posts.delete_post(business)

      conn
      |> put_flash(:info, "Business deleted successfully.")
      |> redirect(to: business_path(conn, :index))
    else
      unauthorized_redirect(conn)
    end
  end

  defp unauthorized_redirect(conn) do
    conn
    |> put_flash(:error, "Unauthorized.")
    |> redirect(to: business_path(conn, :index))
  end
end
