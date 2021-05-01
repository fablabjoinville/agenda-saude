Patient.create!(
  name: 'vaccinated marvin',
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
  vaccine = Vaccine.first!

  first_appointment = patient.appointments.create!(
    start: Time.zone.yesterday.at_beginning_of_day,
    end: Time.zone.yesterday.at_beginning_of_day,
    ubs: ubs
  )

  result = ReceptionService.new(first_appointment).check_in_and_out(vaccine)
  ReceptionService.new(result.next_appointment).check_in_and_out(vaccine)
end
