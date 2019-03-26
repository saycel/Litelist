defmodule Litelist.Repo.Migrations.CreatePostTypes do
  use Ecto.Migration

  def change do
    create table(:post_types) do
      add :name, :string, required: true
      add :form_data, :jsonb, required: true

      timestamps()
    end

  end
end
