defmodule Litelist.SearchTest do
  use Litelist.DataCase, async: true

  alias Litelist.Posts.Post

  alias Litelist.Repo
  alias Litelist.Factory
  alias Litelist.Posts.Search

  describe "full text search" do
    setup do
      Factory.insert(:job, %{title: "my title"})
      Factory.insert(:job, %{title: "my second title"})
      Factory.insert(:job, %{description: "my description"})
      Factory.insert(:job, %{description: "soft delete", soft_delete: true})

      # elixir won't allow to return simply :ok, so I added a nothing variable
      {:ok, nothing_variable: %{attr: nil}}
    end

    test "searches for a complete word" do
      p =
        Post
        |> Search.run("description")

      results = Repo.all(p)
      assert length(results) == 1

      p2 =
        Post
        |> Search.run("title")

      results2 = Repo.all(p2)
      assert length(results2) == 2
    end

    test "does not match on short words, or on short queries (3 character min)" do
      p =
        Post
        |> Search.run("my")

      results = Repo.all(p)
      assert Enum.empty?(results)

      p2 =
        Post
        |> Search.run("t")

      results2 = Repo.all(p2)
      assert Enum.empty?(results2)
    end

    test "returns no results on word that doesn't exist" do
      p =
        Post
        |> Search.run("zzzzzzzzzzzzzzzz")

      results = Repo.all(p)
      assert Enum.empty?(results)
    end

    test "returns results on partial words" do
      p =
        Post
        |> Search.run("desc")

      results = Repo.all(p)
      assert length(results) == 1
    end

    test "returns multiple results for multiple words" do
      p =
        Post
        |> Search.run("title description")

      results = Repo.all(p)
      assert length(results) == 3
    end

    test "handles whitespace" do
      p =
        Post
        |> Search.run("  title  ")

      results = Repo.all(p)
      assert length(results) == 2
    end
  end
end
