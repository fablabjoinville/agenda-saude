# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.new
user.name = 'mlabs'
user.password = 'dontpanic'
user.password_confirmation = 'dontpanic'
user.save!

ubs = Ubs.new
ubs.name = 'UBSF America'
ubs.user = user
ubs.shift_start = '9:00'
ubs.break_start = '12:30'
ubs.break_end = '13:30'
ubs.shift_end = '17:00'
ubs.slot_interval_minutes = 15
ubs.save!

patient = Patient.new
patient.name = 'marvin'
patient.cpf = '489.408.380-92'
patient.mother_name = 'num sei'
patient.birth_date = '01/01/1980'
patient.phone = '12345678'
patient.neighborhood = 'Centro'
patient.save!
