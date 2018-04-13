defmodule Litelist.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text
      add :discussion_id, references(:discussions, on_delete: :nothing)
      add :neighbor_id, references(:neighbors, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:discussion_id])
    create index(:comments, [:neighbor_id])
  end
end
