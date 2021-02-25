patient = Patient.new(
  name: 'marvin',
  cpf: command_options['cpf'],
  mother_name: 'Tristeza',
  birth_date: '1943-01-31',
  public_place: 'Rua',
  place_number: '200',
  neighborhood: 'Glória',
  phone: '(47) 91234-5678'
)
patient.groups << Group.find_by(name: 'Trabalhador(a) da Saúde')
patient.save!
