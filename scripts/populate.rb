require 'smarter_csv'
require 'securerandom'

@users = []

def create_ubs
  csv = SmarterCSV.process('scripts/ubs_com_endereco.csv')

  csv.each do |row|
    cnes = row[:cnes]
    hex = SecureRandom.hex

    @users << { cnes: cnes, hex: hex }

    user = User.create(
      name: cnes,
      password: hex,
      password_confirmation: hex
    )

    Ubs.create(
      name: row[:nome_unidade],
      neighborhood: row[:bairro],
      cnes: cnes,
      phone: row[:telefone],
      address: row[:endereco],
      user: user,
      shift_start: '9:00',
      break_start: '12:30',
      break_end: '13:30',
      shift_end: '17:00',
      slot_interval_minutes: 15,
      active: false
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
