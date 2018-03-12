defmodule LitelistWeb.EmergencyInformationController do
  use LitelistWeb, :controller

  alias Litelist.Posts
  alias Litelist.Posts.EmergencyInformation

  def index(conn, _params) do
    emergency_information = Posts.list_emergency_information()
    render(conn, "index.html", emergency_information: emergency_information)
  end

  def new(conn, _params) do
    changeset = Posts.change_emergency_information(%EmergencyInformation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"emergency_information" => emergency_information_params}) do
    case Posts.create_emergency_information(emergency_information_params) do
      {:ok, emergency_information} ->
        conn
        |> put_flash(:info, "Emergency information created successfully.")
        |> redirect(to: emergency_information_path(conn, :show, emergency_information))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    emergency_information = Posts.get_emergency_information!(id)
    render(conn, "show.html", emergency_information: emergency_information)
  end

  def edit(conn, %{"id" => id}) do
    emergency_information = Posts.get_emergency_information!(id)
    changeset = Posts.change_emergency_information(emergency_information)
    render(conn, "edit.html", emergency_information: emergency_information, changeset: changeset)
  end

  def update(conn, %{"id" => id, "emergency_information" => emergency_information_params}) do
    emergency_information = Posts.get_emergency_information!(id)

    case Posts.update_emergency_information(emergency_information, emergency_information_params) do
      {:ok, emergency_information} ->
        conn
        |> put_flash(:info, "Emergency information updated successfully.")
        |> redirect(to: emergency_information_path(conn, :show, emergency_information))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", emergency_information: emergency_information, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    emergency_information = Posts.get_emergency_information!(id)
    {:ok, _emergency_information} = Posts.delete_emergency_information(emergency_information)

    conn
    |> put_flash(:info, "Emergency information deleted successfully.")
    |> redirect(to: emergency_information_path(conn, :index))
  end
end
