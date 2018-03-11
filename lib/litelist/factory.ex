defmodule Litelist.Factory do
  @moduledoc """
  The home for all factories.
  """
  use ExMachina.Ecto, repo: Litelist.Repo

  alias Litelist.Auth.Neighbor
  alias Litelist.Posts.Post
  alias LitelistWeb.Utils.SharedUtils
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
  ForSale's use the Post Schema
  ## How to
    build(:for_sale)
    build(:for_sale, %{title: '1984 Mazda'})
    insert(:for_sale)
  """
  def for_sale_factory do
    title = FakerElixir.Commerce.product
    slug = SharedUtils.slugify(title)
    %Post{
      title: title,
      slug: slug,
      contact_info: Faker.Internet.email,
      description: Faker.Lorem.sentences(3..5),
      price: Faker.Number.decimal(2, 2),
      neighbor_id: insert(:neighbor).id,
      type: "for_sale",
      url: FakerElixir.Lorem.characters(5..10)
    }
  end

  @doc """
  Job factory
  Job's use the Post Schema
  ## How to
    build(:job)
    build(:job, %{title: 'summer job'})
    insert(:job)
  """
  def job_factory do
    title = Faker.Lorem.words(3)
    slug = SharedUtils.slugify(title)
    %Post{
      title: Faker.Lorem.words(3),
      slug: slug,
      location: FakerElixir.Address.street_address,
      position_name: FakerElixir.Name.title,
      company_name: FakerElixir.App.name,
      contact_info: Faker.Internet.email,
      start_date: FakerElixir.Date.forward(1..2),
      end_date: FakerElixir.Date.forward(11..12),
      description: Faker.Lorem.sentences(3..5),
      salary: "$10/hr",
      neighbor_id: insert(:neighbor).id,
      type: "job",
      url: FakerElixir.Lorem.characters(5..10)
    }
  end
end
