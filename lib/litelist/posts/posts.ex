defmodule Litelist.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Litelist.Repo

  alias Litelist.Posts.ForSale

  alias Litelist.Util
  @doc """
  Returns the list of for_sales.

  ## Examples

      iex> list_for_sales()
      [%ForSale{}, ...]

  """
  def list_for_sales do
    Repo.all(ForSale)
  end

  @doc """
  Gets a single for_sale.

  Raises `Ecto.NoResultsError` if the For sale does not exist.

  ## Examples

      iex> get_for_sale!(123)
      %ForSale{}

      iex> get_for_sale!(456)
      ** (Ecto.NoResultsError)

  """
  def get_for_sale!(id), do: Repo.get!(ForSale, id)

  @doc """
  Creates a for_sale.

  ## Examples

      iex> create_for_sale(neighbor_id, %{field: value})
      {:ok, %ForSale{}}

      iex> create_for_sale(nil, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_for_sale(neighbor_id, attrs \\ %{}) do
    slug = Util.slugify(attrs["title"])
    generated_attrs = %{
      "slug" => slug,
      "neighbor_id" => neighbor_id
    }

    merged_attrs = Map.merge(generated_attrs, attrs)

    %ForSale{}
    |> ForSale.changeset(merged_attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a for_sale.

  ## Examples

      iex> update_for_sale(for_sale, %{field: new_value})
      {:ok, %ForSale{}}

      iex> update_for_sale(for_sale, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_for_sale(%ForSale{} = for_sale, attrs) do
    slug = Util.slugify(attrs["title"])
    generated_attrs = %{
      "slug" => slug
    }
    merged_attrs = Map.merge(generated_attrs, attrs)
    for_sale
    |> ForSale.changeset(merged_attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ForSale.

  ## Examples

      iex> delete_for_sale(for_sale)
      {:ok, %ForSale{}}

      iex> delete_for_sale(for_sale)
      {:error, %Ecto.Changeset{}}

  """
  def delete_for_sale(%ForSale{} = for_sale) do
    Repo.delete(for_sale)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking for_sale changes.

  ## Examples

      iex> change_for_sale(for_sale)
      %Ecto.Changeset{source: %ForSale{}}

  """
  def change_for_sale(%ForSale{} = for_sale) do
    ForSale.changeset(for_sale, %{})
  end
end
