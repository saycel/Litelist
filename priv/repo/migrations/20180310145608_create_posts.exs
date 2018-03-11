defmodule Litelist.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :type, :string
      add :title, :string
      add :description, :text
      add :price, :float
      add :slug, :string
      add :url, :string
      add :location, :string
      add :contact_info, :string
      add :salary, :string
      add :position_name, :string
      add :company_name, :string
      add :neighbor_id, :integer
      add :start_date, :date
      add :end_date, :date
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      timestamps()
    end

    create index(:posts, [:neighbor_id])
    create index(:posts, [:title])
    create index(:posts, [:type])
    create unique_index(:posts, [:url])
    create index(:posts, [:start_date])
    create index(:posts, [:start_time])
  end
end
