require 'smarter_csv'
require 'securerandom'

@users = []

def create_ubs
  csv = SmarterCSV.process('scripts/ubs_com_endereco.csv')

  csv.each do |row|
    cnes = row[:cnes]
    hex = SecureRandom.hex

    begin
      user = User.create(
        name: cnes,
        password: hex,
        password_confirmation: hex
      )
    rescue
      puts "Usuario ja cadastrado."
      next
    end

    @users << { cnes: cnes, hex: hex }

    begin
      ubs = Ubs.create(
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
        saturday_shift_start: '9:00',
        saturday_break_start: '12:30',
        saturday_break_end: '13:30',
        saturday_shift_end: '17:00',
        slot_interval_minutes: 15,
        active: false,
        open_saturday: false
      )
    rescue
      puts "UBS ja cadastrada."
    end
  end
end

def create_relations
  csv = SmarterCSV.process('scripts/bairros_x_ubs.csv')

  csv.each do |row|
    ubs = Ubs.find_by(cnes: row[:cnes])
    ubs.neighborhoods << Neighborhood.find_or_create_by(name: row[:bairro])
    ubs.neighborhoods = ubs.neighborhoods.uniq
    ubs.save!
  end
end

def rename_name_ubs
  Ubs.find_each do |ubs|
    ubs.name.gsub("Ubsf", "UBSF")
    ubs.update_attributes(ubs.name)
  end
end
