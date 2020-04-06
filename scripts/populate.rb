require 'smarter_csv'

def create_ubs
  csv = SmarterCSV.process('scripts/ubs_com_endereco.csv')
  csv.each do |row|
    Ubs.create(
      name: row[:nome_unidade],
      neighborhood: row[:bairro],
      cnes: row[:cnes],
      phone: row[:telefone],
      address: row[:endereco],
      user: User.first,
      shift_start: '9:00',
      break_start: '12:30',
      break_end: '13:30',
      shift_end: '17:00',
      slot_interval_minutes: 15,
    )
  end
end

def create_relations
  csv = SmarterCSV.process('scripts/bairros_x_unidade_referencia.csv')

  csv.each do |row|
    ubs = Ubs.find_by(cnes: row[:cnes])

    neighborhood_name = row[:bairro]

    neighborhood = Neighborhood.find_by(name: neighborhood_name)
    neighborhood ||= Neighborhood.create(name: neighborhood_name)

    ubs.neighborhoods << neighborhood
    ubs.save!
  end
end

create_ubs
create_relations
