defmodule Litelist.Repo.Migrations.CreateDiscussionComments do
  use Ecto.Migration

  def change do
    create table(:discussion_comments) do
      add :body, :string
      add :neighbor_id, references(:neighbors, on_delete: :nothing)
      add :discussion_id, references(:discussions, on_delete: :nothing)

      timestamps()
    end

    create index(:discussion_comments, [:neighbor_id])
    create index(:discussion_comments, [:discussion_id])
  end
end
