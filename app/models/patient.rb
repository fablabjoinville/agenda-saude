class Patient < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, authentication_keys: [:cpf]

  MAX_LOGIN_ATTEMPTS = 2

  SLOTS_WINDOW_IN_DAYS = ENV['SLOTS_WINDOW_IN_DAYS']&.to_i || 3

  has_many :appointments, dependent: :destroy do
    # Returns the last available active appointment
    def current
      order(:start).active.includes(:ubs).last
    end
  end
  has_and_belongs_to_many :groups
  belongs_to :main_ubs, class_name: 'Ubs'
  belongs_to :last_appointment, class_name: 'Appointment', optional: true

  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true, cpf_format: true
  validates :mother_name, presence: true
  validates :birth_date, presence: true
  validates :phone, presence: true, phone_format: true
  validates :neighborhood, presence: true

  validate :valid_birth_date

  # Only set new main_ubs if it is empty or there was a change to the neighborhood
  before_validation :set_main_ubs!, if: proc { |r| r.neighborhood_changed? || r.main_ubs_id.blank? }

  scope :bedridden, -> { where(bedridden: true) }

  # TODO: remove `chronic` field from schema
  enum target_audience: [:kid, :elderly, :chronic, :disabled, :pregnant, :postpartum, :teacher, :over_55, :without_target]

  def first_appointment
    appointments.where.not(check_out: nil).order(:start).first
  end

  def can_schedule?
    schedule_start_time = Time.zone.now
    schedule_end_time = (schedule_start_time + SLOTS_WINDOW_IN_DAYS.days).end_of_day

    conditions_service = ConditionService.new(schedule_start_time, schedule_end_time)

    conditions_service.patient_in_available_group(self)
  end

  def has_future_appointments?
    appointments.
      future.
      active.
      any?
  end

  def in_group?(name)
    groups.map(&:name).include?(name)
  end

  def set_main_ubs!
    self.main_ubs =
      # samples an active ubs near the patient neighborhood
      Neighborhood.find_by(name: neighborhood)&.active_ubs&.sample ||
      # samples any active ubs
      Ubs.active.sample ||
      # samples any inactive ubs
      Ubs.all.sample
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def increase_login_attempts
    update!(login_attempts: login_attempts + 1)
  end

  def remaining_attempts
    MAX_LOGIN_ATTEMPTS - login_attempts
  end

  def blocked?
    login_attempts >= MAX_LOGIN_ATTEMPTS
  end

  def bedridden?
    bedridden
  end

  def unblock!
    update!(login_attempts: 0)
  end

  def encrypted_password
    ''
  end

  def age
    ((Time.zone.now - birth_date.to_time) / 1.year.seconds).floor
  end

  def vaccinated?
    last_appointment&.second_dose && last_appointment&.check_out.present?
  end

  def allowed?
    can_schedule? || has_future_appointments?
  end

  private

  def valid_birth_date
    Date.parse(birth_date)
  rescue ArgumentError
    errors.add(:birth_date, :invalid)
  end
end
