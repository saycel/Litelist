defmodule Litelist.Repo.Migrations.DropUrlIndexFromPosts do
  use Ecto.Migration

  def change do
    drop index(:posts, [:url])
  end
end
