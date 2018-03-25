# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Litelist.Repo.insert!(%Litelist.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Litelist.Factory

neighbor = Factory.insert(:neighbor, %{username: "neighbor"})
admin = Factory.insert(:neighbor, %{username: "admin", admin: true})

Factory.insert_list(2, :job, %{neighbor_id: admin.id})
Factory.insert_list(2, :event, %{neighbor_id: admin.id})
Factory.insert_list(2, :business, %{neighbor_id: admin.id})
Factory.insert_list(2, :emergency_information, %{neighbor_id: admin.id})
Factory.insert_list(2, :for_sale, %{neighbor_id: admin.id})

Factory.insert_list(2, :job, %{neighbor_id: neighbor.id})
Factory.insert_list(2, :event, %{neighbor_id: neighbor.id})
Factory.insert_list(2, :business, %{neighbor_id: neighbor.id})
Factory.insert_list(2, :emergency_information, %{neighbor_id: neighbor.id})
Factory.insert_list(2, :for_sale, %{neighbor_id: neighbor.id})