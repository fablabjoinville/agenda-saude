begin_date = 0.days.from_now.to_date.in_time_zone

%w[
  82920382640
  41869202309
  82194769668
  24834517136
  71097596877
  29344755574
  95975258790
  45963347149
  89452953136
  45445585654
].each_with_index do |cpf, i|
  patient = Patient.create!(
    name: "marvin#{i + 10}",
    cpf: cpf,
    mother_name: 'Tristeza',
    birth_date: '1920-06-24',
    phone: '(47) 91234-5678',
    public_place: 'Rua das Flores',
    place_number: '1',
    neighborhood: Neighborhood.find_by!(name: 'América'),
    groups: [Group.find_by!(name: 'Trabalhador(a) da Saúde')],
    user_updated_at: Time.zone.now
  )

  today_range = begin_date.beginning_of_day..begin_date.end_of_day
  appointment = Appointment.where(patient_id: nil, start: today_range).order(:start).last
  appointment.update!(patient_id: patient.id)

  patient.save!
end
