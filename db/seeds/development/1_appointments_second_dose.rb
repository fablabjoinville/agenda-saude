today = Time.zone.now.at_beginning_of_day
second_appointment_start = today + 7.hours + 40.minutes
second_appointment_end = today + 8.hours
end_of_day_minutes = [600, 620, 640, 660, 680, 700]

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

  time_multiplier = end_of_day_minutes.sample.minutes

  Appointment.create!(
    start: second_appointment_start - 4.weeks + time_multiplier,
    end: second_appointment_end - 4.weeks + time_multiplier,
    patient_id: patient.id,
    active: true,
    check_in: second_appointment_start - 4.weeks + time_multiplier,
    check_out: second_appointment_start - 4.weeks + 10.minutes + time_multiplier,
    vaccine_name: 'astra_zeneca',
    ubs: Ubs.first!
  )
end
