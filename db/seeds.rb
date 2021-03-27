# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

mlabs = User.new.tap do |user|
  user.name = 'mlabs'
  user.password = 'dontpanic'
  user.password_confirmation = 'dontpanic'
  user.save!
end

mlabs_two = User.new.tap do |user|
  user.name = 'mlabs_two'
  user.password = 'dontpanic'
  user.password_confirmation = 'dontpanic'
  user.save!
end

america = Neighborhood.new.tap do |neighborhood|
  neighborhood.name = 'América'
  neighborhood.save!
end

gloria = Neighborhood.new.tap do |neighborhood|
  neighborhood.name = 'Glória'
  neighborhood.save!
end

ubsf_america = Ubs.new.tap do |ubs|
  ubs.name = 'UBSF America'
  ubs.user = mlabs
  ubs.neighborhoods << america
  ubs.neighborhood = america
  ubs.address = 'Rua Magrathea, 42'
  ubs.phone = '(47) 3443-3443'
  ubs.shift_start = '9:00'
  ubs.break_start = '12:30'
  ubs.break_end = '13:30'
  ubs.shift_end = '17:00'
  ubs.slot_interval_minutes = 20
  ubs.active = true
  ubs.save!
end

ubsf_gloria = Ubs.new.tap do |ubs|
  ubs.name = 'UBSF Gloria'
  ubs.user = mlabs_two
  ubs.neighborhood = gloria
  ubs.neighborhoods << gloria
  ubs.address = 'Rua dos Bobos, 0'
  ubs.phone = '(47) 3443-3455'
  ubs.shift_start = '9:00'
  ubs.break_start = '12:30'
  ubs.break_end = '13:30'
  ubs.shift_end = '17:00'
  ubs.slot_interval_minutes = 15
  ubs.save!
end

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
  Group.create!(name: name)
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
  Group.create!(name: subgroup, parent_group_id: Group.find_by!(name: 'Portador(a) de comorbidade').id)
end

[
  'Área da assistência/tratamento',
  'Administrativo e outros setores',
  'Estagiário da área da Saúde',
  'Atua em Hospital',
].each do |subgroup|
  Group.create!(name: subgroup, parent_group_id: Group.find_by!(name: 'Trabalhador(a) da Saúde').id)
end

[
  'Professor(a) em sala de aula',
  'Administrativo e outros setores',
].each do |subgroup|
  Group.create!(name: subgroup, parent_group_id: Group.find_by!(name: 'Trabalhador(a) da Educação').id)
end

[
  'Oficial em atividade de linha de frente',
  'Oficial em atividade administrativa',
].each do |subgroup|
  Group.create!(name: subgroup, parent_group_id: Group.find_by!(name: 'Trabalhador(a) das Forças de Seguranças e Salvamento').id)
end

## SECOND DOSE PATIENTS ##

current_time = Time.now.in_time_zone
begin_date = 0.days.from_now.to_date.in_time_zone
finish_date = 3.days.from_now.to_date.in_time_zone

range = begin_date..finish_date

today = Time.zone.now.at_beginning_of_day
second_appointment_start = today + 7.hours + 40.minutes
second_appointment_end = today + 8.hours

end_of_day_minutes = [600, 620, 640, 660, 680, 700]

%w[
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
].each_with_index do |cpf, i|
  patient = Patient.new.tap do |patient|
    patient.name = "marvin#{i}"
    patient.cpf = cpf
    patient.mother_name = 'Tristeza'
    patient.birth_date = '1920-01-31'
    patient.phone = '(47) 91234-5678'
    patient.neighborhood = 'América'
    patient.groups << Group.find_by!(name: 'Trabalhador(a) da Saúde')
    patient.save!
  end

  time_multiplier = end_of_day_minutes.sample.minutes

  Appointment.create!(
    start: second_appointment_start - 4.weeks + time_multiplier,
    end: second_appointment_end - 4.weeks + time_multiplier,
    patient_id: patient.id,
    second_dose: false,
    active: true,
    vaccine_name: 'coronavac',
    check_in: second_appointment_start - 4.weeks + time_multiplier,
    check_out: second_appointment_start - 4.weeks + 10.minutes + time_multiplier,
    ubs: ubsf_america,
    group: Group.find_by(name: 'Trabalhador(a) da Saúde'),
    commorbidity: false
  )

  second_appointment = Appointment.create!(
    start: second_appointment_start + time_multiplier,
    end: second_appointment_end + time_multiplier,
    patient_id: patient.id,
    second_dose: true,
    active: true,
    vaccine_name: 'coronavac',
    ubs: ubsf_america,
    group: Group.find_by(name: 'Trabalhador(a) da Saúde'),
    commorbidity: false
  )

  patient.update!(last_appointment: second_appointment)
end

## TIME SLOTS / APPOINTMENTS ##

# Config first Ubs
ubsf_america.create_time_slot_generation_config!(ubs_id: ubsf_america.id).tap do |config|
  config[:windows] = [
    { start_time: '07:40', end_time: '08:00', slots: 6 },
    { start_time: '08:00', end_time: '16:20', slots: 8 },
    { start_time: '16:20', end_time: '22:00', slots: 4 }
  ]
  config[:max_appointment_time_ahead] = 0
  config[:group] = Group.find_by(name: 'Trabalhador(a) da Saúde')
  config[:min_age] = 60
  config[:commorbidity] = false
  config.save!
end

# Config second Ubs
ubsf_gloria.create_time_slot_generation_config!(ubs_id: ubsf_gloria.id).tap do |config|
  config[:windows] = [
    { start_time: '08:00', end_time: '12:00', slots: 4 },
    { start_time: '12:00', end_time: '16:00', slots: 2 }
  ]
  config[:max_appointment_time_ahead] = 0
  config[:group] = nil
  config[:min_age] = 75
  config[:commorbidity] = true
  config.save!
end

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
worker.generate_ubs_time_slots(ubsf_america, worker_opts, current_time)

worker.generate_ubs_time_slots(ubsf_gloria, worker_opts, current_time)

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
].each_with_index do |cpf, i|
  patient = Patient.new
  patient.name = "marvin#{i+10}"
  patient.cpf = cpf
  patient.mother_name = 'Tristeza'
  patient.birth_date = '1920-06-24'
  patient.phone = '(47) 91234-5678'
  patient.neighborhood = 'América'
  patient.groups << Group.find_by!(name: 'Trabalhador(a) da Saúde')
  patient.save!

  today_range = begin_date.beginning_of_day..begin_date.end_of_day

  appointment = Appointment.where(patient_id: nil, start: today_range).order(:start).last
  appointment.update(patient_id: patient.id)

  patient.appointments << appointment
  patient.last_appointment = appointment
  patient.save!
end
