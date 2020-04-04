# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u = User.new
u.name = 'mlabs'
u.password = 'dontpanic'
u.password_confirmation = 'dontpanic'
u.save!

ubs = Ubs.new
ubs.name = 'UBSF America'
ubs.user = u
ubs.save!
