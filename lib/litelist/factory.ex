defmodule Litelist.Factory do
  @moduledoc """
  The home for all factories.
  """
  use ExMachina.Ecto, repo: Litelist.Repo

  alias Litelist.Auth.Neighbor
  alias Litelist.Posts.Post
  alias LitelistWeb.Utils.SharedUtils
  alias FakerElixir, as: Faker
  alias Litelist.Moderation.Flag
  alias Litelist.Discussions.Discussion
  alias Litelist.Comments.Comment
  alias Litelist.Settings.Settings

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
      first_name: FakerElixir.Name.first_name,
      last_name: FakerElixir.Name.last_name,
      password: Bcrypt.hash_pwd_salt("password"),
      admin: false
    }
  end

  @doc """
  Admin factory

  ## How to
    build(:admin)
    build(:admin, %{username: 'doe'})
    insert(:admin)
  """
  def admin_factory do
    %Neighbor{
      username: Faker.Internet.user_name,
      first_name: FakerElixir.Name.first_name,
      last_name: FakerElixir.Name.last_name,
      password: Bcrypt.hash_pwd_salt("password"),
      admin: true
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
      url: FakerElixir.Lorem.characters(5..10),
      soft_delete: false
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
      title: title,
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
      url: FakerElixir.Lorem.characters(5..10),
      soft_delete: false
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
      title: title,
      slug: slug,
      location: FakerElixir.Address.street_address,
      contact_info: Faker.Internet.email,
      start_time: FakerElixir.Date.forward(1..2),
      end_time: FakerElixir.Date.forward(11..12),
      description: Faker.Lorem.sentences(1..2),
      neighbor_id: insert(:neighbor).id,
      type: "event",
      url: FakerElixir.Lorem.characters(5..10),
      soft_delete: false
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
      title: title,
      slug: slug,
      location: FakerElixir.Address.street_address,
      contact_info: Faker.Internet.email,
      description: Faker.Lorem.sentences(1..2),
      neighbor_id: insert(:neighbor).id,
      type: "business",
      url: FakerElixir.Lorem.characters(5..10),
      soft_delete: false
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
      title: title,
      slug: slug,
      contact_info: Faker.Internet.email,
      description: Faker.Lorem.sentences(1..2),
      neighbor_id: insert(:neighbor).id,
      type: "emergency_information",
      url: FakerElixir.Lorem.characters(5..10),
      soft_delete: false
    }
  end

  @doc """
  Flag factory
  ## How to
    build(:flag)
    build(:flag, %{description: 'not cool'})
    insert(:business)
  """
  def flag_factory do
    %Flag{
      description: Faker.Lorem.sentences(1..2),
      status: "pending",
      type: "incorrect_information",      
      admin_response: Faker.Lorem.sentences(1),
      neighbor_id: insert(:neighbor).id,
      post_id: insert(:job).id
    }
  end

  @doc """
  Discussion factory
  ## How to
    build(:discussion)
    build(:discussion, %{description: 'funding for new park'})
    insert(:discussion)
  """
  def discussion_factory do
    title = FakerElixir.Commerce.product
    slug = SharedUtils.slugify(title)
    %Discussion{
      title: title,
      slug: slug,
      description: Faker.Lorem.sentences(1..2),
      url: FakerElixir.Lorem.characters(11..15)
    }
  end

  @doc """
  Comments factory
  ## How to
    build(:comments)
    build(:comments, %{post_id: post.id})
    insert(:comments)
  """
  def comment_factory do
    text = FakerElixir.Lorem.sentences(2)
    discussion_id = insert(:discussion).id
    neighbor_id = insert(:neighbor).id
    %Comment{
      text: text,
      discussion_id: discussion_id,
      post_id: nil,
      neighbor_id: neighbor_id 
    }
  end

  @doc """
  Settings factory
  ## How to
    build(:settings)
    build(:settings, %{name: "some name"})
    insert(:settings)
  """
  def settings_factory do
    name = FakerElixir.Address.city
    max_flagged_posts = Enum.random(5..10)
    allow_replies = false
    %Settings{
      name: name,
      max_flagged_posts: max_flagged_posts,
      allow_replies: allow_replies
    }
  end
end
