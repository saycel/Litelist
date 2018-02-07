defmodule Litelist.Factory do
  use ExMachina.Ecto, repo: Litelist.Repo
  
  alias Litelist.Auth.Neighbor
  alias FakerElixir, as: Faker

  def neighbor_factory do
    %Neighbor{
      username: FakerElixir.Internet.user_name,
      password: Faker.Internet.password(:normal)
    }
  end
end