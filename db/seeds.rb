# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.first
Villain.create!(
  user: user,
  name: "El Blanco",
  drive: "to amass more power and influence",
  conditions: "* Angry\n* Afraid\n* Guilty",
  moves: "* Pretend to be an innocent street musician\n* Send coded messages through his songs\n* Smuggle powerful weapons in his guitar case\n* Call on Los Muertos thugs for backup",
  abilities: "None",
  description: "Though Marco Capello is not the only leader Los Muertos have, he is definitely one of the most feared, known for his ruthlessness, skill in battle, and flair for the dramatic. Growing up in a poor neighborhood in Dorado, he was an outcast and bullied for his albinism, so he sympathized with Los Muertos' message of feeling left behind by society. Instead of getting tattoos, which might damage his skin, he took to wearing a skull mask, and without it he can pass for an innocent street musician. Turning his old nickname of \"El Blanco\" from an insult into a title, he rose quickly through the ranks, going from an errand-boy to a hitman to eventually becoming the boss of his local branch, and his ambitions show no sign of slowing down."
)
