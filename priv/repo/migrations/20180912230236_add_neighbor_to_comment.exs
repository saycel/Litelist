defmodule Litelist.Repo.Migrations.AddNeighborToComment do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :neighbor_id, references(:neighbors, on_delete: :nothing)
    end
    create index(:comments, [:neighbor_id])
  end
end
