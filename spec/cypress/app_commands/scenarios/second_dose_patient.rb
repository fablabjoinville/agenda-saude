require 'timecop'

Patient.create!(
  name: 'second dose marvin',
  cpf: command_options['cpf'],
  mother_name: 'Tristeza',
  birth_date: '1920-06-24',
  phone: '(47) 91234-5678',
  public_place: 'Rua das Flores',
  place_number: '1',
  neighborhood: 'América',
  groups: [Group.find_by!(name: 'Trabalhador(a) da Saúde')],
  user_updated_at: Time.zone.now
).tap do |patient|
  days_ago = command_options['days_ago'].days.ago
  vaccine = Vaccine.find_by!(name: command_options['vaccine'])
  ubs = Ubs.first!

  Timecop.freeze(days_ago) do
    first_appointment = patient.appointments.create!(
      start: Time.zone.now,
      end: Time.zone.now + 15.minutes,
      ubs: ubs
    )

    ReceptionService.new(first_appointment).check_in_and_out(vaccine)
  end
end
