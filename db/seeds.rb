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
ubs.phone = '(47) 3443-3443'
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
other_ubs.phone = '(47) 3443-3455'
other_ubs.shift_start = '9:00'
other_ubs.break_start = '12:30'
other_ubs.break_end = '13:30'
other_ubs.shift_end = '17:00'
other_ubs.slot_interval_minutes = 15
other_ubs.save!

[
  'Trabalhador(a) da Saúde',
  'Trabalhador(a) da Educação',
  'Trabalhador(a) das Forças de Seguranças e Salvamento',
  'Forças Armadas',
  'Portador(a) de comorbidade',
  'Trabalhador(a) de transporte coletivo rodoviário de passageiros urbano e de longoprazo',
  'Trabalhador(a) de transporte metroviário e ferroviário',
  'Trabalhador(a) do transporte aéreo',
  'Trabalhador(a) do transporte aquaviário',
  'Caminhoneiro(a)',
  'Trabalhador(a) portuário',
  'Trabalhador(a) da construção civil',
  'Pessoa com deficiência permanente grave',
  'Não me encaixo em nenhum dos grupos listados',
].each do |name|
  Group.create(name: name)
end

[
  'Diabetes mellitus',
  'Pneumopatias graves',
  'Hipertensão ',
  'Doenças cardiovasculares',
  'Doença cerebrovascular',
  'Doença renal crônica',
  'Imunossuprimidos',
  'Anemia falciforme',
  'Obesidade mórbida (IMC >=40)',
  'Síndrome de down',
  'Outra(s)',
].each do |subgroup|
  Group.create(name: subgroup, parent_group_id: Group.find_by(name: 'Portador(a) de comorbidade').id)
end

[
  'Área da assistência/tratamento',
  'Administrativo e outros setores',
  'Estagiário da área da Saúde',
].each do |subgroup|
  Group.create(name: subgroup, parent_group_id: Group.find_by(name: 'Trabalhador(a) da Saúde').id)
end

[
  'Professor(a) em sala de aula',
  'Administrativo e outros setores',
].each do |subgroup|
  Group.create(name: subgroup, parent_group_id: Group.find_by(name: 'Trabalhador(a) da Educação').id)
end

[
  'Oficial em atividade de linha de frente',
  'Oficial em atividade administrativa',
].each do |subgroup|
  Group.create(name: subgroup, parent_group_id: Group.find_by(name: 'Trabalhador(a) das Forças de Seguranças e Salvamento').id)
end

## TIME SLOTS / APPOINTMENTS ##

windows = [
  { start_time: '7:40', end_time: '08:00', slots: 6 },
  { start_time: '08:00', end_time: '16:20', slots: 8 },
  { start_time: '16:20', end_time: '23:40', slots: 4 }
]

# dates for first and second dose appointments
begin_date = 0.days.from_now.to_date.in_time_zone
finish_date = 3.days.from_now.to_date.in_time_zone

begin_second_date = begin_date + 4.weeks
finish_second_date = finish_date + 4.weeks

create_slot = lambda do |attributes|
  Appointment.create(attributes)
end

service = TimeSlotGenerationService.new(
  create_slot: create_slot
)

[
  # Options for first dose day
  TimeSlotGenerationService::Options.new(
    ubs_id: ubs.id,
    start_date: begin_date.to_datetime,
    end_date: finish_date.to_datetime,
    windows: windows,
    slot_interval_minutes: ubs.slot_interval_minutes,
    weekdays: [*0..6],
    excluded_dates: [],
  ),
  # Options for second dose day
  TimeSlotGenerationService::Options.new(
    ubs_id: ubs.id,
    start_date: begin_second_date.to_datetime,
    end_date: finish_second_date.to_datetime,
    windows: windows,
    slot_interval_minutes: ubs.slot_interval_minutes,
    weekdays: [*0..6],
    excluded_dates: [],
  )
].each do |option|
  ActiveRecord::Base.transaction { service.execute(option) }
end

## PATIENTS ##

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

range = begin_date..finish_date

10.times do |i|
  patient = Patient.new
  patient.name = "marvin#{i}"
  patient.cpf = cpfs[i]
  patient.mother_name = 'Natureza'
  patient.birth_date = '1979-06-24'
  patient.phone = '(47) 91234-5678'
  patient.neighborhood = 'América'
  patient.save!

  appointment = Appointment.where(patient_id: nil, start: range).order('RANDOM()').first
  appointment.update(patient_id: patient.id)

  patient.appointments << appointment
  patient.last_appointment = appointment
  patient.save!
end
