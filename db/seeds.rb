# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
%w[Afraid Angry Guilty Hopeless Insecure].each do |word|
  Condition.find_or_create_by(name: word)
end
# Generate slugs:
User.find_each(&:save)
Villain.find_each(&:save)
