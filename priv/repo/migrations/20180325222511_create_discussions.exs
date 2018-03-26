defmodule Litelist.Repo.Migrations.CreateDiscussions do
  use Ecto.Migration

  def change do
    create table(:discussions) do
      add :title, :string
      add :description, :text
      add :slug, :string
      add :neighbor_id, references(:neighbors, on_delete: :nothing)

      timestamps()
    end

    create index(:discussions, [:neighbor_id])
  end
end
