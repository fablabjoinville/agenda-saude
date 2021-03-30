class Appointment < ApplicationRecord
  belongs_to :ubs
  belongs_to :patient, optional: true

  SLOTS_WINDOW_IN_DAYS = ENV['SLOTS_WINDOW_IN_DAYS']&.to_i || 7

  scope :today, -> { where(start: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

  scope :checked_in, -> { where.not(check_in: nil) }
  scope :not_checked_in, -> { where(check_in: nil) }

  scope :checked_out, -> { where.not(check_out: nil) }
  scope :not_checked_out, -> { where(check_out: nil) }

  scope :scheduled, -> { where.not(patient_id: nil) }

  scope :future, -> { where(arel_table[:start].gt(Time.zone.now)) }

  scope :not_scheduled, -> { where(patient_id: nil) }

  scope :active, -> { where(active: true) }
  scope :suspended, -> { where(active: false) }

  # Where the UBS is active
  # Needs to be left_joins due to query on AppointmentScheduler#open_times_per_ubs, to allow us to get proper results
  # when used with DISTINCT
  scope :active_ubs, -> { left_joins(:ubs).where(Ubs.arel_table[:active].eq(true)) }

  # Active and not checked in or out (regardless if in the past or future)
  scope :waiting, -> { not_checked_in.not_checked_out }

  scope :available_doses, lambda {
                            active_ubs
                              .active
                              .waiting
                              .not_scheduled
                          }

  scope :search_for, lambda { |text|
    joins(:patient)
      .where(
        Patient.arel_table[:cpf]
          .eq(Patient.parse_cpf(text)) # Search for CPF without . and -
          .or(Patient.arel_table[:name].matches("%#{text.strip}%"))
      )
  }

  def in_allowed_check_in_window?
    start > Time.zone.now.beginning_of_day && start < Time.zone.now.end_of_day
  end

  # Is this appointment active?
  def active?
    active
  end

  # Is this appointment suspended?
  def suspended?
    !active?
  end

  # Have the patient checked out?
  def checked_out?
    check_out.present?
  end

  # Have the patient checked in?
  def checked_in?
    check_in.present?
  end

  # Is this appointment still waiting for the patient to check in?
  def waiting?
    !checked_in?
  end

  def state
    return :suspended if suspended?
    return :checked_out if checked_out?
    return :checked_in if checked_in?

    :waiting
  end
end
