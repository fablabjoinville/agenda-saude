class Patient < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, authentication_keys: [:cpf]

  MAX_LOGIN_ATTEMPTS = 2

  SLOTS_WINDOW_IN_DAYS = ENV['SLOTS_WINDOW_IN_DAYS']&.to_i || 3

  has_many :appointments, dependent: :destroy
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

  after_initialize :set_main_ubs

  scope :bedridden, -> { where(bedridden: true) }

  # TODO: remove `chronic` field from schema
  enum target_audience: [:kid, :elderly, :chronic, :disabled, :pregnant, :postpartum, :teacher, :over_55, :without_target]

  def current_appointment
    appointments.order(:start).select(&:active?).last
  end

  def first_appointment
    appointments.where.not(check_out: nil).order(:start).first
  end

  def can_see_appointment?
    return true if has_future_appointments?
  end

  def can_schedule?
    schedule_start_time = Time.zone.now
    schedule_end_time = (schedule_start_time + SLOTS_WINDOW_IN_DAYS.days).end_of_day

    groups_available = schedule_groups_available(schedule_start_time, schedule_end_time)

    groups_available.each do |group_available|
      group_id = group_available[0][0]
      min_age = group_available[0][1]
      comorbidity = group_available[0][2]
      if group_id == nil && min_age > 0 && comorbidity == false
        return true if age >= min_age
      elsif group_id == nil && min_age > 0 && comorbidity == true
        return true if age >= min_age && groups.include?(Group.find_by(name: 'Portador(a) de comorbidade'))
      elsif group_id != nil && min_age > 0 && comorbidity == false
        return true if groups.include?(Group.find(group_id)) && age >= min_age
      elsif group_id != nil && min_age > 0 && comorbidity == true
        return true if groups.include?(Group.find(group_id)) && age >= min_age && groups.include?(Group.find_by(name: 'Portador(a) de comorbidade'))
      end
    end
    false
  end

  def has_future_appointments?
    appointments
      .where('start >= ? AND active = TRUE', Time.zone.now)
      .exists?
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

  private

  def schedule_groups_available(start_time, end_time)
    groups_available = []
    Ubs.where(active: true).each do |ubs|
      appointments_available = Appointment.where(start: start_time..end_time, patient_id: nil, active: true, ubs: ubs).select([:id, :ubs_id, :group_id, :min_age, :commorbidity])
      groups_available << appointments_available.pluck(:group_id, :min_age, :commorbidity).uniq
      # groups_available << appointments_available.pluck(:group_id, :min_age, :commorbidity).uniq
    end
    groups_available
  end

  def valid_birth_date
    Date.parse(birth_date)
  rescue ArgumentError
    errors.add(:birth_date, :invalid)
  end
end
