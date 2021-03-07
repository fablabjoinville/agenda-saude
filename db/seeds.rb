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
ubs.slot_interval_minutes = 20
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
  'Atua em Hospital',
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

## SECOND DOSE PATIENTS ##

second_dose_cpfs = %w[
  65622137543
  41759484733
  88949973677
  53847313118
  00455327106
  57984523606
  94831933201
  59711354063
  56105631430
  25532025126
]

current_time = Time.now.in_time_zone
begin_date = 0.days.from_now.to_date.in_time_zone
finish_date = 3.days.from_now.to_date.in_time_zone

range = begin_date..finish_date

today = Time.zone.now.at_beginning_of_day
second_appointment_start = today + 7.hours + 40.minutes
second_appointment_end = today + 8.hours

end_of_day_minutes = [600, 620, 640, 660, 680, 700]

10.times do |i|
  patient = Patient.new
  patient.name = "marvin#{i}"
  patient.cpf = second_dose_cpfs[i]
  patient.mother_name = 'Tristeza'
  patient.birth_date = '1920-01-31'
  patient.phone = '(47) 91234-5678'
  patient.neighborhood = 'América'
  patient.groups << Group.find_by(name: 'Trabalhador(a) da Saúde')
  patient.save!

  time_multiplier = end_of_day_minutes.sample.minutes

  Appointment.create(
    start: second_appointment_start - 4.weeks + time_multiplier,
    end: second_appointment_end - 4.weeks + time_multiplier,
    patient_id: patient.id,
    second_dose: false,
    active: true,
    vaccine_name: 'coronavac',
    check_in: second_appointment_start - 4.weeks + time_multiplier,
    check_out: second_appointment_start - 4.weeks + 10.minutes + time_multiplier,
    ubs: ubs
  )

  second_appointment = Appointment.create(
    start: second_appointment_start + time_multiplier,
    end: second_appointment_end + time_multiplier,
    patient_id: patient.id,
    second_dose: true,
    vaccine_name: 'coronavac',
    active: true,
    ubs: ubs
  )

  patient.update(last_appointment: second_appointment)
end

## TIME SLOTS / APPOINTMENTS ##

config = ubs.create_time_slot_generation_config!(ubs_id: ubs.id)
config[:windows] = [
  { start_time: '07:40', end_time: '08:00', slots: 6 },
  { start_time: '08:00', end_time: '16:20', slots: 8 },
  { start_time: '16:20', end_time: '22:00', slots: 4 }
]
config[:max_appointment_time_ahead] = 0
config.save!

create_slot = lambda do |attributes|
  Appointment.create!(attributes)
end

generation_service = TimeSlotGenerationService.new(create_slot: create_slot)

worker = TimeSlotGenerationWorker.new(
  time_slot_generation_service: generation_service
)

worker_opts = TimeSlotGenerationWorker::Options.new(
  sleep_interval: 5.seconds,
  execution_hour: current_time.hour
)

# mimic successfull worker.execute
worker.generate_ubs_time_slots(ubs, worker_opts, current_time)
TimeSlotGeneratorExecution.where(date: current_time.to_date).update_all(status: 'done')

## FIRST DOSE PATIENTS ##

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

10.times do |i|
  patient = Patient.new
  patient.name = "marvin#{i+10}"
  patient.cpf = cpfs[i]
  patient.mother_name = 'Tristeza'
  patient.birth_date = '1920-06-24'
  patient.phone = '(47) 91234-5678'
  patient.neighborhood = 'América'
  patient.groups << Group.find_by(name: 'Trabalhador(a) da Saúde')
  patient.save!

  appointment = Appointment.where(patient_id: nil, start: range).order('RANDOM()').first
  appointment.update(patient_id: patient.id)

  patient.appointments << appointment
  patient.last_appointment = appointment
  patient.save!
end
