# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create(name: "Test", email: "test@gmail.com", password:"123456");
5.times do |i|
    Recipe.create(name: "Test #{i}", preparationTime: 10 + i, cookingTime: 20 + i, description: "Test #{i}", public: true, user_id: user.id)
    Recipe.create(name: "Test #{i + 1}", preparationTime: 11 + i, cookingTime: 21 + i, description: "Test #{i + 1}", public: false, user_id: user.id)
end