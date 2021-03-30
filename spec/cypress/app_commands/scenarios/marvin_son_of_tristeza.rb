Patient.create!(
  name: 'marvin',
  cpf: command_options['cpf'],
  mother_name: 'Tristeza',
  birth_date: '1920-06-24',
  phone: '(47) 91234-5678',
  public_place: 'Rua das Flores',
  place_number: '1',
  neighborhood: 'Glória',
  groups: [Group.find_by!(name: 'Trabalhador(a) da Saúde')]
)
