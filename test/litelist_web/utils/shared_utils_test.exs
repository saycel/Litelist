defmodule LitelistWeb.SharedUtilsTest do
    use Litelist.DataCase
    alias LitelistWeb.Utils.SharedUtils

    describe "slugify" do
        test "test if param is nil" do
            assert SharedUtils.slugify(nil) == nil
        end
  
        test "test if param is not nil" do
            string1 = ""
            expected = ""

            string2 = "test"
            expected2 = "test"

            string3 = "test with spaces"
            expected3 = "test-with-spaces"

            assert SharedUtils.slugify(string1) == expected
            assert SharedUtils.slugify(string2) == expected2
            assert SharedUtils.slugify(string3) == expected3
        end
    end

    describe "add_generated_params" do
        test "create" do
            title = "my title"
            type = "type"
            slug = "my-title"
            neighbor_id = 1
            action = :create

            params = %{
                "title" => title
            }

            conn = %{
                assigns: %{
                    current_neighbor: %{
                        id: neighbor_id
                    }
                }
            }

            expected = %{
                "title" => title,
                "type" => type,
                "neighbor_id" => neighbor_id,
                "slug" => slug
            }

            assert SharedUtils.add_generated_params(params, conn, type, action) == expected
        end

        test "update" do
            title = "my title"
            generated_slug = "my-title"
            original_slug = "something-else"
            action = :update

            params = %{
                "title" => title,
                "slug" => original_slug
            }

            expected = %{
                "title" => title,
                "slug" => generated_slug
            }

            assert SharedUtils.add_generated_params(params, action) == expected
        end
    end

    describe "admin?" do
        test "returns expected value" do
            admin = %{admin: true}
            not_admin = %{admin: false}

            assert SharedUtils.admin?(admin) == true
            assert SharedUtils.admin?(not_admin) == false
        end
    end

    describe "owner_and_type_check?" do
        test "returns expected value" do
            neighbor_id = 1
            wrong_id = 2
            type = :event
            wrong_type = :wrong

            neighbor = %{id: neighbor_id}
            wrong_neighbor = %{id: wrong_id}
            resource = %{neighbor_id: neighbor_id, type: type}

            assert SharedUtils.owner_and_type_check?(neighbor, resource, type) == true      
            assert SharedUtils.owner_and_type_check?(wrong_neighbor, resource, type) == false   
            assert SharedUtils.owner_and_type_check?(neighbor, resource, wrong_type) == false                 
        end
    end

    describe "permission?" do
        test "returns expected value" do
            neighbor_id = 1
            wrong_id = 2
            type = :event
            wrong_type = :wrong

            resource = %{neighbor_id: neighbor_id, type: type}
            neighbor = %{id: neighbor_id, admin: false}
            wrong_neighbor = %{id: wrong_id, admin: false}
            admin_neighbor = %{id: wrong_id, admin: true}

            assert SharedUtils.permission?(neighbor, resource, type) == true
            assert SharedUtils.permission?(admin_neighbor, resource, type) == true

            assert SharedUtils.permission?(wrong_neighbor, resource, type) == false
            assert SharedUtils.permission?(neighbor, resource, wrong_type) == false
        end
    end

    describe "match_type?" do
        test "returns expected value" do
            match = :match
            no_match = :no_match
            resource = %{type: match}

            assert SharedUtils.match_type?(resource, match) == true
            assert SharedUtils.match_type?(resource, no_match) == false
        end
    end

    describe "resource_owner?" do
        test "returns expected value" do
            right_id = 1
            wrong_id = 2

            neighbor = %{id: right_id}
            wrong_neighbor = %{id: wrong_id}
            resource = %{neighbor_id: right_id}

            assert SharedUtils.resource_owner?(neighbor, resource) == true
            assert SharedUtils.resource_owner?(wrong_neighbor, resource) == false
        end
    end
end