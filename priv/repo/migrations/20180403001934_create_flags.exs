defmodule Litelist.Repo.Migrations.CreateFlags do
  use Ecto.Migration

  def change do
    create table(:flags) do
      add :type, :string
      add :description, :text
      add :status, :string
      add :admin_response, :text
      add :post_id, references(:posts, on_delete: :nothing)
      add :neighbor_id, references(:neighbor, on_delete: :nothing)

      timestamps()
    end

    create index(:flags, [:post_id])
    create index(:flags, [:neighbor_id])
  end
end
