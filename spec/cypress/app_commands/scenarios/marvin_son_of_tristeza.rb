Patient.create!(
  name: 'marvin',
  cpf: command_options['cpf'],
  mother_name: 'Tristeza',
  birth_date: command_options['birth_date'] || '1920-06-24',
  phone: '(47) 91234-5678',
  public_place: 'Rua das Flores',
  place_number: '1',
  neighborhood: Neighborhood.find_by!(name: 'Glória'),
  groups: [Group.find_by!(name: 'Trabalhador(a) da Saúde'), Group.find_by!(name: 'Anemia falciforme')],
  user_updated_at: Time.zone.now
)
