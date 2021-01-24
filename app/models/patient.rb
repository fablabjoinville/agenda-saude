class Patient < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, authentication_keys: [:cpf]

  MAX_LOGIN_ATTEMPTS = 2

  DAYS_FOR_NEW_APPOINTMENT = 30

  CONDITIONS = {
    'Trabalhador(a) da Saúde' => ->(patient) { patient.in_group?('Trabalhador(a) da Saúde') },
    'Pessoa acima de 75 anos' => ->(patient) { patient.age >= 75 },
    'Pessoas de 60 anos ou mais institucionalizadas' => ->(patient) { patient.age >= 60 && patient.in_group?('Institucionalizado(a)') },
    'População Indígena' => ->(patient) { patient.in_group?('Indígena') },
  }

  has_many :appointments, dependent: :destroy
  has_and_belongs_to_many :groups
  belongs_to :main_ubs, class_name: 'Ubs'
  belongs_to :last_appointment, class_name: 'Appointment'

  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true, cpf_format: true
  validates :mother_name, presence: true
  validates :birth_date, presence: true
  validates :phone, presence: true, phone_format: true
  validates :neighborhood, presence: true

  after_initialize :set_main_ubs

  scope :bedridden, -> { where(bedridden: true) }

  # TODO: remove `chronic` field from schema
  enum target_audience: [:kid, :elderly, :chronic, :disabled, :pregnant, :postpartum, :teacher, :over_55, :without_target]

  def active_appointments
    appointments.select(&:active?)
  end

  def current_appointment
    active_appointments.last
  end

  def can_schedule?
    CONDITIONS.values.any? do |condition|
      condition.call(self)
    end
  end

  def in_group?(name)
    groups.map(&:name).include?(name)
  end

  def set_main_ubs
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
    bedridden == true
  end

  def wait_appointment_time?
    last_appointment != nil and
    last_appointment < Time.zone.now and
    Time.zone.now < last_appointment + DAYS_FOR_NEW_APPOINTMENT.days
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
end
