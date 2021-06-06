class ReceptionService
  class MismatchVaccine < StandardError; end

  class MissingVaccine < StandardError; end

  attr_reader :appointment

  def initialize(appointment)
    @appointment = appointment
  end

  def check_in
    appointment.update!(check_in: Time.zone.now)
  end

  def check_out(vaccine)
    raise MissingVaccine unless vaccine.is_a?(Vaccine)
    raise MismatchVaccine if appointment.follow_up_for_dose && vaccine != appointment.follow_up_for_dose.vaccine

    Appointment.transaction do
      dose = new_dose(vaccine)
      appointment.update!(check_out: Time.zone.now)

      next_appointment = create_follow_up_appointment!(dose)
      dose.follow_up_appointment = next_appointment
      dose.save!

      OpenStruct.new dose: dose, next_appointment: next_appointment
    end
  end

  def check_in_and_out(vaccine)
    check_in
    check_out(vaccine)
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
        active: true
      }
      a.save!
    end
  end
  # rubocop:enable Metrics/AbcSize

  def new_dose(vaccine)
    appointment.build_dose patient_id: appointment.patient_id,
                           vaccine: vaccine,
                           sequence_number: (appointment.follow_up_for_dose&.sequence_number || 0) + 1
  end
end
