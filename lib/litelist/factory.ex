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
  Neighbor factory

  ## How to
    build(:neighbor)
    build(:neighbor, %{username: 'doe'})
    insert(:neighbor)
  """
  def for_sale_factory do
    %ForSale{
      title: Faker.Lorem.words(3),
      description: FakerElixir.Lorem.sentences(3..5),
      price: FakerElixir.Number.decimal(3, 2),
      contact_info: FakerElixir.Internet.email
    }
  end
end
