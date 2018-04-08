defmodule Litelist.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :type, :string
      add :post_id, references(:posts, on_delete: :delete_all)
      add :neighbor_id, references(:neighbors, on_delete: :delete_all)

      timestamps()
    end

    create index(:images, [:post_id])
    create index(:images, [:neighbor_id])
  end
end
