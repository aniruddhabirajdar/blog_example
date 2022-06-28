# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.delete_all
User.where({ id: 1, user_name: "TEST 1" }).first_or_create
User.where({ id: 2, user_name: "TEST 2" }).first_or_create
User.where({ id: 3, user_name: "TEST 3" }).first_or_create
User.where({ user_name: "GUEST" }).first_or_create
