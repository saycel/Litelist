defmodule LitelistWeb.JobControllerTest do
  use LitelistWeb.ConnCase
  
  alias Litelist.Factory
  alias Litelist.Auth.Guardian

  @create_attrs %{"contact_info" => "some contact_info", "description" => "some description", "salary" => "$10/hr", "title" => "some title", "url" => "my-cool-url", "company_name" => "some company", "position_name" => "boss", "location" => "1234 5th st queens"}
  @update_attrs %{"contact_info" => "some updated contact_info", "description" => "some updated description", "salary" => "$11/hr", "title" => "some updated title", "company_name" => "new company name", "position_name" => "new position name", "location" => "5432 1st st bronx"}
  @invalid_attrs %{"contact_info" => nil, "description" => nil, "salary" => nil, "title" => nil}

  setup do
    neighbor = Factory.insert(:neighbor)
    admin = Factory.insert(:neighbor, %{admin: true})
    job = Factory.insert(:job, neighbor_id: neighbor.id)
    not_my_job = Factory.insert(:job)
    {:ok, neighbor: neighbor, job: job, not_my_job: not_my_job, admin: admin}
  end

  describe "index" do
    test "lists all jobs", %{conn: conn} do
      conn = conn
        |> get(job_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Jobs"
    end
  end

  describe "new job" do
    test "renders form", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(job_path(conn, :new))
      
      assert html_response(conn, 200) =~ "New Job"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> get(job_path(conn, :new))
      
      assert response(conn, 401)
    end
  end
  
  describe "create job" do
    test "redirects to show when data is valid", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> post(job_path(conn, :create), post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == job_path(conn, :show, id)

      conn = conn
        |> recycle()
        |> login_neighbor(neighbor)

      conn = get conn, job_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Job"
    end

    test "renders errors when data is invalid", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> post(job_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Job"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> post(job_path(conn, :create), post: @create_attrs)
      assert response(conn, 401)
    end

    test "renders errors when url is not unique", %{conn: conn, neighbor: neighbor} do
      Factory.insert(:job, %{url: "my-cool-url"})

      conn = conn
        |> login_neighbor(neighbor)
        |> post(job_path(conn, :create), post: @create_attrs)
      assert html_response(conn, 200) =~ "New Job"
    end
  end

  describe "edit job" do
    test "renders form for editing chosen job", %{conn: conn, job: job, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(job_path(conn, :edit, job))
      assert html_response(conn, 200) =~ "Edit Job"
    end

    test "renders form for editing chosen job if admin", %{conn: conn, job: job, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> get(job_path(conn, :edit, job))
      assert html_response(conn, 200) =~ "Edit Job"
    end

    test "redirects to index if job was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_job: not_my_job} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(job_path(conn, :edit, not_my_job))
      assert redirected_to(conn) == job_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, job: job} do
      conn = conn
        |> get(job_path(conn, :edit, job))
      
      assert response(conn, 401)
    end
  end

  describe "update job" do

    test "redirects when data is valid", %{conn: conn, job: job, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(job_path(conn, :update, job), post: @update_attrs)

      assert redirected_to(conn) == job_path(conn, :show, job)

      conn = conn
        |> recycle()
        |> login_neighbor(neighbor)

      conn = get conn, job_path(conn, :show, job)
      assert html_response(conn, 200) =~ "some updated contact_info"
    end

    test "redirects when data is valid as an admin", %{conn: conn, job: job, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> put(job_path(conn, :update, job), post: @update_attrs)

      assert redirected_to(conn) == job_path(conn, :show, job)

      conn = conn
        |> recycle()
        |> login_neighbor(admin)

      conn = get conn, job_path(conn, :show, job)
      assert html_response(conn, 200) =~ "some updated contact_info"
    end

    test "renders errors when data is invalid", %{conn: conn, job: job, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(job_path(conn, :update, job), post: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Job"
    end

    test "redirects to index if job was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_job: not_my_job} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(job_path(conn, :update, not_my_job), post: @invalid_attrs)

        assert redirected_to(conn) == job_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, job: job} do
      conn = conn
        |> put(job_path(conn, :update, job), job: @invalid_attrs)

      assert response(conn, 401)
    end
  end

  describe "delete job" do

    test "deletes chosen job", %{conn: conn, job: job, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> delete(job_path(conn, :delete, job))

      assert redirected_to(conn) == job_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, job_path(conn, :show, job)
      end
    end

    test "deletes chosen job as an admin", %{conn: conn, job: job, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> delete(job_path(conn, :delete, job))

      assert redirected_to(conn) == job_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, job_path(conn, :show, job)
      end
    end

    test "redirects to index if job was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_job: not_my_job} do
      conn = conn
        |> login_neighbor(neighbor)
        |> delete(job_path(conn, :delete, not_my_job))

        assert redirected_to(conn) == job_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, job: job} do
      conn = conn
        |> delete(job_path(conn, :delete, job))

      assert response(conn, 401)
    end
  end

  defp login_neighbor(conn, neighbor) do
    {:ok, token, _} = Guardian.encode_and_sign(neighbor, %{}, token_type: :access)
    conn
      |> put_req_header("authorization", "bearer: " <> token)
  end
end
