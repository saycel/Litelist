defmodule Litelist.Repo.Migrations.AddRealNamesToNeighbors do
  use Ecto.Migration

  def change do
    alter table(:neighbors) do
      add :first_name, :string
      add :last_name, :string
    end
  end
end
