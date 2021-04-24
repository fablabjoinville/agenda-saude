Patient.create!(
  name: 'second dose marvin',
  cpf: command_options['cpf'],
  mother_name: 'Tristeza',
  birth_date: '1920-06-24',
  phone: '(47) 91234-5678',
  public_place: 'Rua das Flores',
  place_number: '1',
  neighborhood: 'América',
  groups: [Group.find_by!(name: 'Trabalhador(a) da Saúde')]
).tap do |patient|
  ubs = Ubs.first!

  first_appointment = patient.appointments.create!(
    start: Time.zone.yesterday.at_beginning_of_day,
    end: Time.zone.yesterday.at_beginning_of_day,
    vaccine_name: 'coronavac',
    check_in: Time.zone.yesterday.at_beginning_of_day,
    check_out: Time.zone.yesterday.at_beginning_of_day,
    active: true,
    ubs: ubs
  )

  patient.appointments.create!(
    start: command_options['days_from_now'].days.from_now.end_of_day - 15.minutes,
    end: command_options['days_from_now'].days.from_now.end_of_day,
    vaccine_name: 'coronavac',
    check_in: nil,
    check_out: nil,
    active: true,
    ubs: ubs
  )

  vaccine = Vaccine.find_by!(legacy_name: 'coronavac')
  sequence_number = patient.doses.where(vaccine: vaccine).count
  patient.doses.create! appointment: first_appointment,
                        vaccine: vaccine,
                        sequence_number: sequence_number + 1,
                        created_at: first_appointment.check_out,
                        updated_at: first_appointment.check_out
end
