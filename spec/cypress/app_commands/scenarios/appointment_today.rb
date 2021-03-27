ubs = Ubs.find_by!(active: true)
patient = Patient.find_by!(cpf: command_options['cpf'])
time = Time.zone.today.at_end_of_day

Appointment.create!(
  start: time,
  end: time,
  patient: patient,
  active: true,
  ubs: ubs
)
