class Appointment < ApplicationRecord
  belongs_to :patient, optional: true
  belongs_to :ubs
  has_one :dose, dependent: :restrict_with_exception
  has_one :follow_up_for_dose, class_name: 'Dose', foreign_key: :follow_up_appointment_id,
                               dependent: :restrict_with_exception,
                               inverse_of: :follow_up_appointment

  scope :today, -> { where(start: Time.zone.now.all_day) }

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

  # For follow ups, can only be canceled or rescheduled close to the date.
  def can_cancel_and_reschedule?
    return true unless follow_up_for_dose

    Time.zone.now > can_change_after
  end

  # Patients can only cancel or reschedule after a certain cutoff, in this case being "schedule_up_to_days" related with
  # when they should get the vaccine.
  def can_change_after
    follow_up_for_dose.created_at + follow_up_for_dose.follow_up_in_days.days -
      Rails.configuration.x.schedule_up_to_days.days
  end

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

  # Applied, to be applied, or likely sequence number
  def dose_sequence_number
    return nil unless patient_id

    dose&.sequence_number || follow_up_for_dose&.next_sequence_number || 1
  end

  # Applied, or to be applied vaccine
  def dose_vaccine
    dose&.vaccine || follow_up_for_dose&.vaccine
  end
end
