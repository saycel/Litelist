defmodule Litelist.Repo.Migrations.CreateForSales do
  use Ecto.Migration

  def change do
    create table(:for_sales) do
      add :title, :string
      add :description, :text
      add :price, :float
      add :contact_info, :string

      timestamps()
    end

  end
end
