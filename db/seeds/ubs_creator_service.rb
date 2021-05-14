require 'smarter_csv'
require 'securerandom'

class UbsCreatorService
  def initialize(ubs_data_basedir:)
    @ubs_csv = File.join(ubs_data_basedir, 'ubs_com_endereco.csv')
    @bairros_csv = File.join(ubs_data_basedir, 'bairros_x_ubs.csv')
  end

  def call
    create_ubs_and_users_from_csv @ubs_csv

    create_ubs_bairros @bairros_csv
  end

  private

  def create_ubs_user(cnes)
    hex = SecureRandom.hex

    User.create name: cnes,
                password: hex,
                password_confirmation: hex
  end

  def create_ubs(row)
    Ubs.create name: row[:nome_unidade],
               neighborhood: row[:bairro],
               cnes: row[:cnes],
               phone: row[:telefone],
               address: row[:endereco],
               shift_start: '9:00',
               break_start: '12:30',
               break_end: '13:30',
               shift_end: '17:00',
               saturday_shift_start: '9:00',
               saturday_break_start: '12:30',
               saturday_break_end: '13:30',
               saturday_shift_end: '17:00',
               slot_interval_minutes: 15,
               active: false
  end

  def create_ubs_and_users_from_csv(ubs_csv)
    Rails.logger.info "Loading #{ubs_csv}"

    csv = SmarterCSV.process ubs_csv

    csv.each do |row|
      user = create_ubs_user row[:cnes]
      ubs = create_ubs row

      ubs.users << user
    rescue StandardError
      Rails.logger.warn "#{row[:cnes]} já existe"
      next
    end
  end

  def create_ubs_bairros(bairros_csv)
    Rails.logger.info "Loading #{bairros_csv}"

    csv = SmarterCSV.process bairros_csv

    csv.each do |row|
      ubs = Ubs.find_by(cnes: row[:cnes])
      ubs.neighborhoods << Neighborhood.find_or_create_by(name: row[:bairro])
      ubs.neighborhoods = ubs.neighborhoods.distinct
    rescue StandardError => e
      Rails.logger.warn e.message
      next
    end
  end
end
