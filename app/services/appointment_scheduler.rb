class AppointmentScheduler
  class NoFreeSlotsAhead < StandardError; end

  ROUNDING = 2.minutes # delta to avoid rounding issues

  CONDITIONS_UNMET = :conditions_unmet
  NO_SLOTS = :no_slots
  SUCCESS = :success

  attr_reader :earliest_allowed, :latest_allowed

  # Scheduler for appointments, enabling appointments to be made between +earliest_allowed+ and +latest_allowed+ dates
  def initialize(earliest_allowed:, latest_allowed:)
    @earliest_allowed = earliest_allowed
    @latest_allowed = latest_allowed
  end

  # Schedules an appointment for +patient+ starting +from+ a given timestamp, optionally with a +ubs_id+ (which can be
  # nil in case we want to schedule on any Ubs available to the +patient+).
  # It will schedule on the first possible time until the +latest_allowed+.
  # Checks if the user can schedule, otherwise returns +CONDITIONS_UNMET+.
  # Looks for appointments, and tries to schedule one. If it can't, it will return +NO_SLOTS+.
  # In case it can, it will also cancel the patient's current schedule for an existing appointment, and in the end it
  # returns +SUCCESS+ and the newly scheduled appointment.
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def schedule(patient:, ubs_id:, from:)
    return [CONDITIONS_UNMET] unless patient.can_schedule?

    current_appointment = patient.appointments.current

    Appointment.transaction(isolation: :repeatable_read) do
      success = update_appointment(
        patient_id: patient.id,
        ubs_id: ubs_id,
        start: rounded_from(from)..latest_allowed
      )
      return [NO_SLOTS] unless success

      new_appointment = patient.appointments.waiting.where.not(id: current_appointment&.id).first!
      if current_appointment
        vaccine_name = current_appointment.vaccine_name
        cancel_schedule(appointment: current_appointment, new_appointment: new_appointment)
        new_appointment.update!(vaccine_name: vaccine_name) # TODO: remove me [jmonteiro]
      end

      # In case patient canceled a follow up in the past and is trying to reschedule it
      dose = patient.doses.where(follow_up_appointment: nil).first
      if dose
        dose.update! follow_up_appointment: new_appointment
        new_appointment.update!(vaccine_name: dose.vaccine.legacy_name) # TODO: remove me [jmonteiro]
      end

      log :schedule, patient.id, new_appointment.id
      [SUCCESS, new_appointment]
    end
  rescue StandardError => e
    ExceptionNotifierService.call(e)

    [NO_SLOTS]
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def log(action, patient_id, appointment_id)
    Rails.logger.info '[AppointmentScheduler logger] ' \
                        "patient #{patient_id} appointment #{appointment_id}: #{action}"
  end

  # Cancels schedule for an appointment for a given patient, in a SQL efficient way
  def cancel_schedule(appointment:, new_appointment: nil)
    log :cancel_schedule, appointment.patient_id, appointment.id

    attributes = { patient: nil, vaccine_name: nil, check_in: nil }

    dose = appointment.follow_up_for_dose

    return appointment.update!(attributes) unless dose

    # For follow up we need to suspend the appointment and update the dose follow up appointment
    appointment.update!(attributes.merge(active: false,
                                         suspend_reason: I18n.t('suspend_reasons.follow_up_canceled_by_user')))
    dose.update! follow_up_appointment: new_appointment
  end

  def open_times_per_ubs(from:, to:, filter_ubs_id: nil)
    from = [from, earliest_allowed].compact.max - ROUNDING

    appointments = Appointment.available_doses
                              .where(start: rounded_from(from)..to)
                              .order(:start) # in chronological order
                              .select(:ubs_id, :start, :end) # only return what we care with

    appointments = appointments.where(ubs_id: filter_ubs_id) if filter_ubs_id

    appointments.distinct # remove duplicates (same as .uniq in pure Ruby)
                .group_by(&:ubs) # transforms it into a Hash grouped by Ubs
  end

  # Returns how many days ahead there are available appointments
  def days_ahead_with_open_slot
    next_available_appointment = Appointment.available_doses
                                            .where(start: earliest_allowed..latest_allowed)
                                            .order(:start)
                                            .pick(:start)

    raise NoFreeSlotsAhead unless next_available_appointment

    ((next_available_appointment - Time.zone.now.end_of_day) / 1.day).ceil
  end

  protected

  # Checks if we can schedule +from+ that time and then rounds to avoid issues with time conversion
  def rounded_from(from)
    [earliest_allowed, from].compact.max - ROUNDING
  end

  def update_appointment(patient_id:, start:, ubs_id:)
    # Single SQL query to update the first available record it can find
    # it will either return 0 if no rows could be found, or 1 if it was able to schedule an appointment
    appointment = Appointment.available_doses
                             .order(:start)
                             .where(start: start)
                             .limit(1)

    appointment = appointment.where(ubs_id: ubs_id) if ubs_id.present?

    appointment
      .update_all(patient_id: patient_id, updated_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
      .positive? # 0 = false, 1 = true
  end
end
