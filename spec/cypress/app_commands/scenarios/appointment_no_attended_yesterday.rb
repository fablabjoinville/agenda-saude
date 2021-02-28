ubs = Ubs.find_by!(active: true)

Appointment.create!(
  start: Time.zone.yesterday,
  end: Time.zone.yesterday + 20.minutes,
  patient: Patient.find_by!(cpf: command_options['cpf']),
  second_dose: false,
  active: true,
  check_in: nil,
  check_out: nil,
  ubs: ubs
)
