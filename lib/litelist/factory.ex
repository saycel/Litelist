defmodule Litelist.Factory do
  use ExMachina.Ecto, repo: Litelist.Repo
  
  alias Litelist.Auth.Neighbor
  alias FakerElixir, as: Faker

  def neighbor_factory do
    %Neighbor{
      username: Faker.Internet.user_name,
      password: Comeonin.Bcrypt.hashpwsalt("password")
    }
  end
end