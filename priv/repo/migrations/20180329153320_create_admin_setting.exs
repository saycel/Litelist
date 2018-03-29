defmodule Litelist.Repo.Migrations.CreateAdmin.Setting do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :flag_count, :integer
      add :site_name, :string
      add :default_replyable, :boolean, default: false, null: false

      timestamps()
    end
  end
end
