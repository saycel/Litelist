defmodule Litelist.Repo.Migrations.AddSoftDeleteToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :soft_delete, :boolean, default: false
    end
  end
end
