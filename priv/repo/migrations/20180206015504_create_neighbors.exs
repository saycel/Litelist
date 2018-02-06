defmodule Litelist.Repo.Migrations.CreateNeighbors do
  use Ecto.Migration

  def change do
    create table(:neighbors) do
      add :username, :string
      add :password, :string

      timestamps()
    end

  end
end
