defmodule Litelist.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :name, :string
      add :max_flagged_posts, :integer
      add :allow_replies, :boolean

      timestamps()
    end
  end
end
