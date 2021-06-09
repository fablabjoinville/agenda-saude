require 'timecop'

Patient.create!(
  name: 'second dose marvin',
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
  vaccine = Vaccine.find_by!(name: command_options['vaccine'])
  ubs = Ubs.first!
  start = command_options['days_ago'].days.ago

  appointment = patient.appointments.create!(
    start: start,
    end: start + ubs.slot_interval_minutes.minutes,
    ubs: ubs
  )

  ReceptionService.new(appointment).check_in(at: start)
  ReceptionService.new(appointment).check_out(vaccine, at: start + ubs.slot_interval_minutes.minutes)
end
