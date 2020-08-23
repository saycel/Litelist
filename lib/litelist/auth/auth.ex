defmodule Litelist.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Litelist.Repo

  alias Litelist.Auth.Neighbor

  alias Bcrypt

  @doc """
  Returns the list of neighbors.

  ## Examples

      iex> list_neighbors()
      [%Neighbor{}, ...]

  """
  def list_neighbors do
    Repo.all(Neighbor)
  end

  @doc """
  Gets a single neighbor.

  Raises `Ecto.NoResultsError` if the Neighbor does not exist.

  ## Examples

      iex> get_neighbor!(123)
      %Neighbor{}

      iex> get_neighbor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_neighbor!(id), do: Repo.get!(Neighbor, id)

  @doc """
  Creates a neighbor.

  ## Examples

      iex> create_neighbor(%{field: value})
      {:ok, %Neighbor{}}

      iex> create_neighbor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_neighbor(attrs \\ %{}) do
    %Neighbor{}
    |> Neighbor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a neighbor.

  ## Examples

      iex> update_neighbor(neighbor, %{field: new_value})
      {:ok, %Neighbor{}}

      iex> update_neighbor(neighbor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_neighbor(%Neighbor{} = neighbor, attrs) do
    neighbor
    |> Neighbor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Neighbor.

  ## Examples

      iex> delete_neighbor(neighbor)
      {:ok, %Neighbor{}}

      iex> delete_neighbor(neighbor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_neighbor(%Neighbor{} = neighbor) do
    Repo.delete(neighbor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking neighbor changes.

  ## Examples

      iex> change_neighbor(neighbor)
      %Ecto.Changeset{source: %Neighbor{}}

  """
  def change_neighbor(%Neighbor{} = neighbor) do
    Neighbor.changeset(neighbor, %{})
  end

  def authenticate_neighbor(username, plain_text_password) do
    query = from n in Neighbor, where: n.username == ^username
    query
    |> Repo.one()
    |> check_password(plain_text_password)
  end

  defp check_password(nil, _), do: {:error, "Incorrect username or password"}

  defp check_password(neighbor, plain_text_password) do
  case Bcrypt.verify_pass(plain_text_password, neighbor.encrypted_password) do
      true -> {:ok, neighbor}
      false -> {:error, "Incorrect username or password"}
    end
  end
end
