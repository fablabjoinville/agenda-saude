vaccine = Vaccine.first
ubs = Ubs.first!

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
  patient = Patient.create!(
    name: "marvin#{i}",
    cpf: cpf,
    mother_name: 'Tristeza',
    birth_date: '1920-01-31',
    phone: '(47) 91234-5678',
    public_place: 'Rua das Flores',
    place_number: '1',
    neighborhood: Neighborhood.find_by!(name: 'América'),
    groups: [Group.find_by!(name: 'Trabalhador(a) da Saúde')],
    user_updated_at: Time.zone.now
  )

  start = Time.zone.now.at_beginning_of_day + 7.hours + # from 7 in the morning
          i * ubs.slot_interval_minutes.minutes - # each slot on a different time
          vaccine.follow_up_in_days(1).days # in the past so 2nd dose is today
  appointment = Appointment.create!(
    start: start,
    end: start + ubs.slot_interval_minutes.minutes,
    patient_id: patient.id,
    active: true,
    ubs: ubs
  )
  ReceptionService.new(appointment).check_in(at: start)
  ReceptionService.new(appointment).check_out(vaccine, at: start + ubs.slot_interval_minutes.minutes)
end
