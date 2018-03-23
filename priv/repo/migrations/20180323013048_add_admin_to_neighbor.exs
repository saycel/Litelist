defmodule Litelist.Repo.Migrations.AddAdminToNeighbor do
  use Ecto.Migration

  def change do
    alter table(:neighbors) do
      add :admin, :boolean, default: false
    end
  end
end
