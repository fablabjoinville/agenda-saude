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

other_user = User.new
other_user.name = 'mlabs_two'
other_user.password = 'dontpanic'
other_user.password_confirmation = 'dontpanic'
other_user.save!

neighborhood = Neighborhood.new
neighborhood.name = 'América'
neighborhood.save!

other_neighborhood = Neighborhood.new
other_neighborhood.name = 'Glória'
other_neighborhood.save!

ubs = Ubs.new
ubs.name = 'UBSF America'
ubs.user = user
ubs.neighborhoods << neighborhood
ubs.neighborhood = neighborhood
ubs.address = 'Rua Magrathea, 42'
ubs.phone = '3443-3443'
ubs.shift_start = '9:00'
ubs.break_start = '12:30'
ubs.break_end = '13:30'
ubs.shift_end = '17:00'
ubs.slot_interval_minutes = 15
ubs.active = true
ubs.valid?
ubs.save!

other_ubs = Ubs.new
other_ubs.name = 'UBSF Gloria'
other_ubs.user = other_user
other_ubs.neighborhood = other_neighborhood
other_ubs.neighborhoods << other_neighborhood
other_ubs.address = 'Rua dos Bobos, 0'
other_ubs.phone = '3443-3455'
other_ubs.shift_start = '9:00'
other_ubs.break_start = '12:30'
other_ubs.break_end = '13:30'
other_ubs.shift_end = '17:00'
other_ubs.slot_interval_minutes = 15
other_ubs.save!

cpfs = %w[
  82920382640
  41869202309
  82194769668
  24834517136
  71097596877
  29344755574
  95975258790
  45963347149
  89452953136
  45445585654
]

ubss = [ubs, other_ubs]

starting_time = Tod::TimeOfDay.parse('9:00')
today = Date.today

10.times do |i|
  patient = Patient.new
  patient.name = "marvin#{i}"
  patient.cpf = cpfs[i]
  patient.mother_name = 'Natureza'
  patient.birth_date = '1979-06-24'
  patient.phone = '12345678'
  patient.neighborhood = 'América'
  patient.save!

  appointment = Appointment.new
  appointment.patient = patient
  appointment.ubs = ubss.sample
  appointment.start = starting_time.on(today)
  appointment.end = (starting_time += 15.minutes).on(today)
  appointment.active = true
  appointment.save!
end
