patient = Patient.new
patient.name = 'second dose marvin'
patient.cpf = command_options['cpf']
patient.mother_name = 'Tristeza'
patient.birth_date = '1920-01-10'
patient.phone = '(47) 91234-5678'
patient.neighborhood = 'América'
patient.groups << Group.find_by(name: 'Trabalhador(a) da Saúde')
patient.save!

ubs = Ubs.first

Appointment.create!(
  start: Time.zone.yesterday.at_beginning_of_day,
  end: Time.zone.yesterday.at_beginning_of_day,
  patient_id: patient.id,
  second_dose: false,
  vaccine_name: 'coronavac',
  check_in: Time.zone.yesterday.at_beginning_of_day,
  check_out: Time.zone.yesterday.at_beginning_of_day,
  active: true,
  ubs: ubs
)

Appointment.create!(
  start: Time.zone.today.end_of_day - 15.minutes,
  end: Time.zone.today.end_of_day,
  patient_id: patient.id,
  second_dose: true,
  vaccine_name: 'coronavac',
  check_in: nil,
  check_out: nil,
  active: true,
  ubs: ubs
)
