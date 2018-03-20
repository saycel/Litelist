defmodule Litelist.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :url, :string
      add :post_id, references(:posts, on_delete: :nothing)

      timestamps()
    end

    create index(:images, [:post_id])
  end
end
