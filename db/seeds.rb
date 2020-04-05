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

ubs = Ubs.new
ubs.name = 'UBSF America'
ubs.user = user
ubs.shift_start = '9:00'
ubs.break_start = '12:30'
ubs.break_end = '13:30'
ubs.shift_end = '17:00'
ubs.slot_interval_minutes = 15
ubs.save!

other_ubs = Ubs.new
other_ubs.name = 'UBSF Gloria'
other_ubs.user = other_user
other_ubs.shift_start = '9:00'
other_ubs.break_start = '12:30'
other_ubs.break_end = '13:30'
other_ubs.shift_end = '17:00'
other_ubs.slot_interval_minutes = 15
other_ubs.save!

cpfs = %w[
  829.203.826-40
  418.692.023-09
  821.947.696-68
  248.345.171-36
  710.975.968-77
  293.447.555-74
  959.752.587-90
  459.633.471-49
  894.529.531-36
  454.455.856-54
]

ubss = [ubs, other_ubs]

10.times do |i|
  patient = Patient.new
  patient.name = "marvin#{i}"
  patient.cpf = cpfs[i]
  patient.mother_name = 'num sei'
  patient.birth_date = '01/01/1980'
  patient.phone = '12345678'
  patient.neighborhood = 'Centro'
  patient.save!

  appointment = Appointment.new
  appointment.patient = patient
  appointment.ubs = ubss.sample
  appointment.start = (i * 5).minutes.from_now
  appointment.end = (i * 5 + 10).minutes.from_now
  appointment.active = true
  appointment.save!
end
