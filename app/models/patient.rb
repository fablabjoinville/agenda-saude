class Patient < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :authentication_keys => [:cpf]

  MAX_LOGIN_ATTEMPTS = 2.freeze

  has_many :appointments, dependent: :destroy

  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true, cpf_format: true
  validates :mother_name, presence: true
  validates :birth_date, presence: true
  validates :phone, presence: true
  validates :neighborhood, presence: true

  def active_appointments
    appointments.select(&:active?)
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

  def unblock!
    update!(login_attempts: 0)
  end

  def years_old
    (Date.today.to_date - Date.parse(patient.birth_date)).to_i / 365
  end

  def encrypted_password
    ''
  end
end
