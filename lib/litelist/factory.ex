defmodule Litelist.Factory do
    # with Ecto
    use ExMachina.Ecto, repo: Litelist.Repo
  
    alias Litelist.Auth.Neighbor
    def neighbor_factory do
      %Neighbor{
        username: sequence(:email, &"email-#{&1}@example.com"),
        password: "password"
      }
    end
  end