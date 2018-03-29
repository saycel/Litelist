defmodule Litelist.Repo.Migrations.IntroducePgSearch do
  use Ecto.Migration

  @moduledoc """
  Create postgres extension and indices
  """

  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION pg_trgm")

    execute("""
    CREATE INDEX posts_trgm_idx ON posts USING GIN (to_tsvector('english',
      title || ' ' || location || ' ' || coalesce(description, ' ')))
    """)
  end

  def down do
    execute("DROP INDEX posts_trgm_idx")
    execute("DROP EXTENSION pg_trgm")
  end
end
