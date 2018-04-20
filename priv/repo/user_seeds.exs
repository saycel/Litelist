# Script for populating the database with users. You can run it as:
#
#     mix run priv/repo/user_seeds.exs


alias Litelist.Factory

neighbor = Factory.insert(:neighbor, %{username: "neighbor"})
admin = Factory.insert(:neighbor, %{username: "admin", admin: true})
