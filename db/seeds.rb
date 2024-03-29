# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

1000.times do
  author = Author.find_or_create_by(name: Faker::Book.author)
  Book.create({
    title: Faker::Book.title,
    author: author,
    genre: Faker::Book.genre,
    description: Faker::Lorem.paragraph
  })
end

