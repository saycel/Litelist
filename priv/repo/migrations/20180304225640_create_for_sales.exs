defmodule Litelist.Repo.Migrations.CreateForSales do
  use Ecto.Migration

  def change do
    create table(:for_sales) do
      add :title, :string
      add :description, :text
      add :price, :float
      add :contact_info, :string
      add :slug, :string
      add :neighbor_id, references(:neighbors, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:for_sales, [:neighbor_id])
  end
end
