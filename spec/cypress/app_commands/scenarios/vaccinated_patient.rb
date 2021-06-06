Patient.create!(
  name: 'vaccinated marvin',
  cpf: command_options['cpf'],
  mother_name: 'Tristeza',
  birth_date: '1920-06-24',
  phone: '(47) 91234-5678',
  public_place: 'Rua das Flores',
  place_number: '1',
  neighborhood: Neighborhood.find_by!(name: 'América'),
  groups: [Group.find_by!(name: 'Trabalhador(a) da Saúde')],
  user_updated_at: Time.zone.now
).tap do |patient|
  vaccine = Vaccine.first!
  ubs = Ubs.first!
  start = Time.zone.now.at_beginning_of_day + 7.hours +
          vaccine.follow_up_in_days(1).days

  appointment = patient.appointments.create!(
    start: start,
    end: start + ubs.slot_interval_minutes.minutes,
    ubs: ubs
  )

  ReceptionService.new(appointment).check_in(at: start)
  result = ReceptionService.new(appointment).check_out(vaccine, at: start + ubs.slot_interval_minutes.minutes)

  ReceptionService.new(result.next_appointment).check_in
  ReceptionService.new(result.next_appointment).check_out(vaccine)
end
