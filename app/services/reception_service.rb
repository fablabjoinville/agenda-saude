class ReceptionService
  class MismatchVaccine < StandardError; end

  class MissingVaccine < StandardError; end

  attr_reader :appointment

  def initialize(appointment)
    @appointment = appointment
  end

  def check_in(at: Time.zone.now)
    appointment.update!(check_in: at)
  end

  def undo_check_in
    Appointment.transaction do
      appointment.update!(check_in: nil)
    end
  end

  def check_out(vaccine, at: Time.zone.now)
    raise MissingVaccine unless vaccine.is_a?(Vaccine)
    raise MismatchVaccine if appointment.follow_up_for_dose && vaccine != appointment.follow_up_for_dose.vaccine

    Appointment.transaction do
      dose = new_dose(vaccine, at: at)
      appointment.update!(check_out: at)

      next_appointment = create_follow_up_appointment!(dose)
      dose.follow_up_appointment = next_appointment
      dose.save!

      OpenStruct.new dose: dose, next_appointment: next_appointment
    end
  end

  def undo_check_out
    Appointment.transaction do
      # Keep this in sync with AppointmentScheduler#cancel_schedule
      appointment.dose&.follow_up_appointment&.update!(
        patient: nil,
        check_in: nil,
        check_out: nil,
        active: false,
        suspend_reason: 'Check-out da dose anterior desfeita por operador.'
      )
      appointment.dose&.destroy
      appointment.update!(check_out: nil)
    end
  end

  private

  # rubocop:disable Metrics/AbcSize
  def create_follow_up_appointment!(dose)
    return nil unless dose.follow_up_in_days

    start = appointment.start + dose.follow_up_in_days.days

    appointment.ubs.appointments.find_or_initialize_by(
      start: start,
      end: start + appointment.ubs.slot_interval_minutes.minutes,
      patient_id: nil,
      check_in: nil,
      check_out: nil
    ).tap do |a|
      a.attributes = {
        patient_id: appointment.patient_id,
        active: true,
        suspend_reason: nil
      }
      a.save!
    end
  end

  # rubocop:enable Metrics/AbcSize

  def new_dose(vaccine, at: Time.zone.now)
    appointment.build_dose patient_id: appointment.patient_id,
                           vaccine: vaccine,
                           sequence_number: (appointment.follow_up_for_dose&.sequence_number || 0) + 1,
                           created_at: at
  end
end
