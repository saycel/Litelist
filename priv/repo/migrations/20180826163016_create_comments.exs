defmodule Litelist.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :text
      add :post_id, references(:posts, on_delete: :nothing)
      add :discussion_id, references(:discussions, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:post_id])
    create index(:comments, [:discussion_id])
  end
end
