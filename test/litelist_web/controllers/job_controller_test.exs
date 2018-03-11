defmodule LitelistWeb.JobControllerTest do
  # use LitelistWeb.ConnCase

  # alias Litelist.Posts

  # @create_attrs %{company_name: "some company_name", contact_info: "some contact_info", description: "some description", end_date: ~D[2010-04-17], location: "some location", position_name: "some position_name", start_date: ~D[2010-04-17], title: "some title", url: "some url"}
  # @update_attrs %{company_name: "some updated company_name", contact_info: "some updated contact_info", description: "some updated description", end_date: ~D[2011-05-18], location: "some updated location", position_name: "some updated position_name", start_date: ~D[2011-05-18], title: "some updated title", url: "some updated url"}
  # @invalid_attrs %{company_name: nil, contact_info: nil, description: nil, end_date: nil, location: nil, position_name: nil, start_date: nil, title: nil, url: nil}

  # def fixture(:job) do
  #   {:ok, job} = Posts.create_job(@create_attrs)
  #   job
  # end

  # describe "index" do
  #   test "lists all jobs", %{conn: conn} do
  #     conn = get conn, job_path(conn, :index)
  #     assert html_response(conn, 200) =~ "Listing Jobs"
  #   end
  # end

  # describe "new job" do
  #   test "renders form", %{conn: conn} do
  #     conn = get conn, job_path(conn, :new)
  #     assert html_response(conn, 200) =~ "New Job"
  #   end
  # end

  # describe "create job" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post conn, job_path(conn, :create), job: @create_attrs

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == job_path(conn, :show, id)

  #     conn = get conn, job_path(conn, :show, id)
  #     assert html_response(conn, 200) =~ "Show Job"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, job_path(conn, :create), job: @invalid_attrs
  #     assert html_response(conn, 200) =~ "New Job"
  #   end
  # end

  # describe "edit job" do
  #   setup [:create_job]

  #   test "renders form for editing chosen job", %{conn: conn, job: job} do
  #     conn = get conn, job_path(conn, :edit, job)
  #     assert html_response(conn, 200) =~ "Edit Job"
  #   end
  # end

  # describe "update job" do
  #   setup [:create_job]

  #   test "redirects when data is valid", %{conn: conn, job: job} do
  #     conn = put conn, job_path(conn, :update, job), job: @update_attrs
  #     assert redirected_to(conn) == job_path(conn, :show, job)

  #     conn = get conn, job_path(conn, :show, job)
  #     assert html_response(conn, 200) =~ "some updated company_name"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, job: job} do
  #     conn = put conn, job_path(conn, :update, job), job: @invalid_attrs
  #     assert html_response(conn, 200) =~ "Edit Job"
  #   end
  # end

  # describe "delete job" do
  #   setup [:create_job]

  #   test "deletes chosen job", %{conn: conn, job: job} do
  #     conn = delete conn, job_path(conn, :delete, job)
  #     assert redirected_to(conn) == job_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get conn, job_path(conn, :show, job)
  #     end
  #   end
  # end

  # defp create_job(_) do
  #   job = fixture(:job)
  #   {:ok, job: job}
  # end
end
