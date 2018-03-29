defmodule Litelist.Factory do
  @moduledoc """
  The home for all factories.
  """
  use ExMachina.Ecto, repo: Litelist.Repo

  alias Litelist.Auth.Neighbor
  alias Litelist.Posts.Post
  alias Litelist.Settings.Setting
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
      password: Comeonin.Bcrypt.hashpwsalt("password"),
      admin: false
    }
  end
  def setting_factory do
    %Setting{
      flag_count: 5,
      site_name: "Bushwick",
      default_replyable: false
    }
  end

  @doc """
  ForSale factory
  ForSales use the Post Schema
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
      description: Faker.Lorem.sentences(1..2),
      price: Faker.Number.decimal(2, 2),
      neighbor_id: insert(:neighbor).id,
      type: "for_sale",
      url: FakerElixir.Lorem.characters(5..10)
    }
  end

  @doc """
  Job factory
  Jobs use the Post Schema
  ## How to
    build(:job)
    build(:job, %{title: 'summer job'})
    insert(:job)
  """
  def job_factory do
    title = FakerElixir.Commerce.product
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
      description: Faker.Lorem.sentences(1..2),
      salary: "$10/hr",
      neighbor_id: insert(:neighbor).id,
      type: "job",
      url: FakerElixir.Lorem.characters(5..10)
    }
  end

  @doc """
  Event factory
  Events use the Post Schema
  ## How to
    build(:event)
    build(:event, %{title: 'block party'})
    insert(:event)
  """
  def event_factory do
    title = FakerElixir.Commerce.product
    slug = SharedUtils.slugify(title)
    %Post{
      title: Faker.Lorem.words(3),
      slug: slug,
      location: FakerElixir.Address.street_address,
      contact_info: Faker.Internet.email,
      start_time: FakerElixir.Date.forward(1..2),
      end_time: FakerElixir.Date.forward(11..12),
      description: Faker.Lorem.sentences(1..2),
      neighbor_id: insert(:neighbor).id,
      type: "event",
      url: FakerElixir.Lorem.characters(5..10)
    }
  end

  @doc """
  Business factory
  Businesses use the Post Schema
  ## How to
    build(:business)
    build(:business, %{title: 'block party'})
    insert(:business)
  """
  def business_factory do
    title = FakerElixir.Commerce.product
    slug = SharedUtils.slugify(title)
    %Post{
      title: Faker.Lorem.words(3),
      slug: slug,
      location: FakerElixir.Address.street_address,
      contact_info: Faker.Internet.email,
      description: Faker.Lorem.sentences(1..2),
      neighbor_id: insert(:neighbor).id,
      type: "business",
      url: FakerElixir.Lorem.characters(5..10)
    }
  end

  @doc """
  EmergencyInformation factory
  EmergencyInformation uses the Post Schema
  ## How to
    build(:business)
    build(:business, %{title: 'block party'})
    insert(:business)
  """
  def emergency_information_factory do
    title = FakerElixir.Commerce.product
    slug = SharedUtils.slugify(title)
    %Post{
      title: Faker.Lorem.words(3),
      slug: slug,
      contact_info: Faker.Internet.email,
      description: Faker.Lorem.sentences(1..2),
      neighbor_id: insert(:neighbor).id,
      type: "emergency_information",
      url: FakerElixir.Lorem.characters(5..10)
    }
  end
end
