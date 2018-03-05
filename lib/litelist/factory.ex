defmodule Litelist.Factory do
  @moduledoc """
  The home for all factories.
  """
  use ExMachina.Ecto, repo: Litelist.Repo

  alias Litelist.Auth.Neighbor
  alias Litelist.Posts.ForSale

  alias FakerElixir, as: Faker

  @doc """
  Neighbor factory

  ## How to
    build(:neighbor)
    build(:neighbor, %{username: 'doe'})
    insert(:neighbor)
  """
  def neighbor_factory do
    %Neighbor{
      username: Faker.Internet.user_name,
      password: Comeonin.Bcrypt.hashpwsalt("password")
    }
  end

  @doc """
  ForSale factory
  ## How to
    build(:for_sale)
    build(:for_sale, %{title: '1984 Mazda'})
    insert(:for_sale)
  """
  def for_sale_factory do
    title = Faker.Lorem.words(3)
    slug = slugify(title)
    
    %ForSale{
      title: title,
      slug: slug,
      contact_info: Faker.Internet.email,
      description: Faker.Lorem.sentences(3..5),
      price: Faker.Number.decimal(2, 2),
      neighbor_id: insert(:neighbor).id
    }
  end

  defp slugify(string) do 
    string
    |> String.downcase
    |> String.replace(" ", "-")
  end
end