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

  patient.appointments.create!(
    start: Time.zone.yesterday.at_beginning_of_day,
    end: Time.zone.yesterday.at_beginning_of_day,
    vaccine_name: 'coronavac',
    check_in: Time.zone.yesterday.at_beginning_of_day,
    check_out: Time.zone.yesterday.at_beginning_of_day,
    active: true,
    ubs: ubs
  )

  patient.appointments.create!(
    start: Time.zone.today.end_of_day - 15.minutes,
    end: Time.zone.today.end_of_day,
    vaccine_name: 'coronavac',
    check_in: nil,
    check_out: nil,
    active: true,
    ubs: ubs
  )
end
