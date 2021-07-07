class Patient < ApplicationRecord
  MAX_LOGIN_ATTEMPTS = 3

  has_many :appointments, dependent: :destroy do
    # Returns the last available active appointment
    def current
      order(:start).active.not_checked_out.includes(:ubs).last
    end
  end

  belongs_to :neighborhood
  has_and_belongs_to_many :groups
  has_many :doses, dependent: :destroy
  has_many :patients_inquiry_answers, dependent: :destroy

  has_many :inquiry_answers, through: :patients_inquiry_answers, dependent: nil

  validates :birthday, presence: true
  validates :cpf, presence: true, uniqueness: true, cpf_format: true
  validates :mother_name, presence: true
  validates :name, presence: true
  validates :neighborhood_id, presence: true
  validates :phone, presence: true, phone_format: true
  validates :place_number, presence: true
  validates :public_place, presence: true

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

  # List all conditions allowed for patient
  def conditions
    Condition.active.can_schedule.select { |condition| condition.allowed? self }
  end

  # Find if any conditions match
  def can_schedule?
    conditions.any?
  end

  # Find if patient was every able to schedule in the past
  def could_schedule_in_the_past?
    Condition.start_at_past.can_schedule.select { |condition| condition.allowed? self }.any?
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

  def age
    @age ||= ((Time.zone.now - Time.zone.parse("#{birthday} 00:00:00")) / 1.year.seconds).floor
  end

  def force_user_update?
    user_updated_at.blank? ||
      user_updated_at < Time.zone.parse(Rails.configuration.x.patient_force_update_before)
  end

  def self.parse_cpf(cpf)
    cpf.gsub(/[^\d]/, '')
  end

  def inquiry_answers_via_questions=(hash)
    self.inquiry_answer_ids = hash.values.flatten
  end
end
