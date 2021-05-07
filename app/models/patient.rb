class Patient < ApplicationRecord
  MAX_LOGIN_ATTEMPTS = 3

  CONDITIONS = {
    # 'População em geral com 60 anos ou mais' =>
    # lambda do |patient|
    #   birthday = patient.birthday.to_time # rubocop:disable Rails/Date timezone is respected
    #   cutoff = Time.zone.now
    #   age = ((cutoff - birthday) / 1.year.seconds).floor
    #   age >= 60
    # end
    'Trabalhadores da saúde segundo OFÍCIO Nº 234/2021/CGPNI/DEIDT/SVS/MS' =>
    lambda do |patient|
      group_ids = [23, 46, 47, 55, 57]

      # age check && check if there's an intersection between arrays
      (group_ids & patient.group_ids).any?
    end
  }.freeze

  has_many :appointments, dependent: :destroy do
    # Returns the last available active appointment
    def current
      order(:start).active.not_checked_out.includes(:ubs).last
    end
  end

  # belongs_to :neighborhood, optional: true # For future use [jmonteiro]
  has_and_belongs_to_many :groups
  has_many :doses, dependent: :destroy # For future use [jmonteiro]

  validates :cpf, presence: true, uniqueness: true, cpf_format: true
  validates :name, presence: true
  validates :birth_date, presence: true
  validates :mother_name, presence: true
  validates :phone, presence: true, phone_format: true
  validates :neighborhood, presence: true
  validates :place_number, presence: true
  validates :public_place, presence: true

  validate :valid_birth_date

  scope :locked, -> { where(arel_table[:login_attempts].gteq(MAX_LOGIN_ATTEMPTS)) }

  scope :search_for, lambda { |text|
    where(
      Patient.arel_table[:cpf]
             .eq(Patient.parse_cpf(text)) # Search for CPF without . and -
             .or(Patient.arel_table[:name].matches("%#{text.strip}%"))
    )
  }

  # Receives CPF, sanitizing everything different from a digit
  def cpf=(string)
    self[:cpf] = Patient.parse_cpf(string)
  end

  def conditions
    CONDITIONS.select { |_, f| f.call(self) }.map { |c, _| c }
  end

  def can_schedule?
    conditions.any?
  end

  def future_appointments?
    appointments
      .future
      .active
      .any?
  end

  # Until we have a proper way to remember vaccines for patients
  def got_first_dose?
    appointments.active.checked_out.count.positive?
  end

  def vaccinated?
    # If there are any doses and the last one doesn't have a follow up date, it means user is vaccinated
    doses.any? && !doses.order(sequence_number: :desc).first!.follow_up_in_days
  end

  def allowed?
    can_schedule? || future_appointments?
  end

  # TODO: Replace birth_date with birthday in the database (setting it to Date instead of String)
  def birthday=(date)
    date = [date[1], date[2].to_s.rjust(2, '0'), date[3].to_s.rjust(2, '0')].join('-') if date.is_a? Hash
    self[:birth_date] = Date.iso8601(date)
  end

  def birthday
    return nil if self[:birth_date].blank?

    Date.iso8601(self[:birth_date])
  rescue Date::Error
    nil
  end

  def mothers_first_name
    mother_name.split.first.downcase.camelize
  end

  def match_mothers_name?(try)
    mothers_first_name == try.downcase.camelize
  end

  def generate_fake_mothers_list!
    update! fake_mothers: MotherNameService.name_list(mothers_first_name)
  end

  def record_failed_login!
    update! login_attempts: login_attempts + 1
  end

  def record_successful_login!
    update! login_attempts: 0, fake_mothers: nil
  end

  def locked?
    remaining_login_attempts <= 0
  end

  def remaining_login_attempts
    MAX_LOGIN_ATTEMPTS - login_attempts
  end

  def self.parse_cpf(cpf)
    cpf.gsub(/[^\d]/, '')
  end

  private

  def valid_birth_date
    errors.add(:birth_date, :invalid) unless birthday
  end
end
