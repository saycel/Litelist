defmodule LitelistWeb.EventControllerTest do
  use LitelistWeb.ConnCase
  
  alias Litelist.Factory
  alias Litelist.Auth.Guardian

  @create_attrs %{contact_info: "some contact_info", description: "some description", end_time: "2010-04-17 14:00:00.000000Z", location: "some location", slug: "some slug", start_time: "2010-04-17 14:00:00.000000Z", title: "some title", url: "my-cool-url"}
  @update_attrs %{contact_info: "some updated contact_info", description: "some updated description", end_time: "2011-05-18 15:01:01.000000Z", location: "some updated location", slug: "some updated slug", start_time: "2011-05-18 15:01:01.000000Z", title: "some updated title"}
  @invalid_attrs %{contact_info: nil, description: nil, end_time: nil, location: nil, slug: nil, start_time: nil, title: nil, type: nil, url: nil}

  setup do
    neighbor = Factory.insert(:neighbor)
    admin = Factory.insert(:neighbor, %{admin: true})
    event = Factory.insert(:event, neighbor_id: neighbor.id)
    not_my_event = Factory.insert(:event)
    not_a_event = Factory.insert(:job)
    {:ok, neighbor: neighbor, event: event, not_my_event: not_my_event, not_a_event: not_a_event, admin: admin}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = conn
        |> get(event_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Events"
    end
  end

  describe "show" do
    test "shows an event if the type matches", %{conn: conn, event: event} do
      conn = conn
        |> get(event_path(conn, :show, event))

      assert html_response(conn, 200) =~ event.title
    end

    test "redirects to index if the type does not match", %{conn: conn, not_a_event: not_a_event} do
      conn = conn
        |> get(event_path(conn, :show, not_a_event))

        assert redirected_to(conn) == event_path(conn, :index)
    end
  end

  describe "new event" do
    test "renders form", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(event_path(conn, :new))
      
      assert html_response(conn, 200) =~ "EVENT POST"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> get(event_path(conn, :new))
      
      assert response(conn, 401)
    end
  end
  
  describe "create event" do
    test "redirects to show when data is valid", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> post(event_path(conn, :create), post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == event_path(conn, :show, id)

      conn = conn
        |> recycle()
        |> login_neighbor(neighbor)

      conn = get conn, event_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Event"
    end

    test "renders errors when data is invalid", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> post(event_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "EVENT POST"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> post(event_path(conn, :create), post: @create_attrs)
      assert response(conn, 401)
    end

    test "renders errors when url is not unique", %{conn: conn, neighbor: neighbor} do
      Factory.insert(:event, %{url: "my-cool-url"})

      conn = conn
        |> login_neighbor(neighbor)
        |> post(event_path(conn, :create), post: @create_attrs)
      assert html_response(conn, 200) =~ "EVENT POST"
    end
  end

  describe "edit event" do
    test "renders form for editing chosen event", %{conn: conn, event: event, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(event_path(conn, :edit, event))
      assert html_response(conn, 200) =~ "TITLE"
    end

    test "renders form for editing chosen event as an admin", %{conn: conn, event: event, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> get(event_path(conn, :edit, event))
      assert html_response(conn, 200) =~ "TITLE"
    end

    test "redirects to index if event was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_event: not_my_event} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(event_path(conn, :edit, not_my_event))
      assert redirected_to(conn) == event_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, event: event} do
      conn = conn
        |> get(event_path(conn, :edit, event))
      
      assert response(conn, 401)
    end
  end

  describe "update event" do

    test "redirects when data is valid", %{conn: conn, event: event, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(event_path(conn, :update, event), post: @update_attrs)

      assert redirected_to(conn) == event_path(conn, :show, event)

      conn = conn
        |> recycle()
        |> login_neighbor(neighbor)

      conn = get conn, event_path(conn, :show, event)
      assert html_response(conn, 200) =~ "some updated contact_info"
    end

    test "redirects when data is valid as an admin", %{conn: conn, event: event, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> put(event_path(conn, :update, event), post: @update_attrs)

      assert redirected_to(conn) == event_path(conn, :show, event)

      conn = conn
        |> recycle()
        |> login_neighbor(admin)

      conn = get conn, event_path(conn, :show, event)
      assert html_response(conn, 200) =~ "some updated contact_info"
    end

    test "renders errors when data is invalid", %{conn: conn, event: event, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(event_path(conn, :update, event), post: @invalid_attrs)

      assert html_response(conn, 200) =~ "TITLE"
    end

    test "redirects to index if event was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_event: not_my_event} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(event_path(conn, :update, not_my_event), post: @invalid_attrs)

        assert redirected_to(conn) == event_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, event: event} do
      conn = conn
        |> put(event_path(conn, :update, event), event: @invalid_attrs)

      assert response(conn, 401)
    end
  end

  describe "delete event" do

    test "deletes chosen event", %{conn: conn, event: event, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> delete(event_path(conn, :delete, event))

      assert redirected_to(conn) == event_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, event_path(conn, :show, event)
      end
    end

    test "deletes chosen event as an admin", %{conn: conn, event: event, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> delete(event_path(conn, :delete, event))

      assert redirected_to(conn) == event_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, event_path(conn, :show, event)
      end
    end

    test "redirects to index if event was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_event: not_my_event} do
      conn = conn
        |> login_neighbor(neighbor)
        |> delete(event_path(conn, :delete, not_my_event))

        assert redirected_to(conn) == event_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, event: event} do
      conn = conn
        |> delete(event_path(conn, :delete, event))

      assert response(conn, 401)
    end
  end

  defp login_neighbor(conn, neighbor) do
    {:ok, token, _} = Guardian.encode_and_sign(neighbor, %{}, token_type: :access)
    conn
      |> put_req_header("authorization", "bearer: " <> token)
  end
end
