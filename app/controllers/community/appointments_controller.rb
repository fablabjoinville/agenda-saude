module Community
  class AppointmentsController < Base
    class CannotCancelAndReschedule < StandardError; end

    def home
      return redirect_to(vaccinated_community_appointments_path) if current_patient.vaccinated?

      @doses = current_patient.doses.includes(:vaccine, appointment: [:ubs])
      @appointment = current_patient.appointments.current

      return if @appointment

      return unless current_patient.can_schedule?

      @appointments_count = Appointment.available_doses
                                       .where(start: from..to)
                                       .count
    end

    # Reschedules appointment (only if patient already has one scheduled)
    def index
      appointment_can_cancel_and_reschedule

      # If patient already had a dose, keep it in the same UBS.
      # This is an optimized query, hence a little odd using +pick+s.
      ubs_id = Appointment.where(id: current_patient.doses.pick(:appointment_id)).pick(:ubs_id)

      @days = parse_days
      @appointments = scheduler.open_times_per_ubs(from: @days.days.from_now.beginning_of_day,
                                                   to: @days.days.from_now.end_of_day,
                                                   filter_ubs_id: ubs_id)
    rescue AppointmentScheduler::NoFreeSlotsAhead
      redirect_to home_community_appointments_path, flash: { alert: 'Não há vagas disponíveis para reagendamento.' }
    end

    def create
      appointment_can_cancel_and_reschedule

      # If patient already had a dose, keep it in the same UBS
      ubs_id = current_patient.doses.first&.appointment&.ubs_id || create_params[:ubs_id].presence

      result, new_appointment = scheduler.schedule(
        patient: current_patient,
        ubs_id: ubs_id,
        from: parse_start.presence
      )

      redirect_to home_community_appointments_path,
                  flash: message_for(result, appointment: new_appointment, desired_start: parse_start)
    end

    # NOTE: we are ignoring params[:id] in here
    def destroy
      @appointment = appointment_can_cancel_and_reschedule

      scheduler.cancel_schedule(appointment: @appointment)

      redirect_to home_community_appointments_path
    end

    def vaccinated
      return redirect_to(home_community_appointments_path) unless current_patient.vaccinated?

      @patient = current_patient
      @doses = current_patient.doses.order(:sequence_number)
    end

    private

    def appointment_can_cancel_and_reschedule
      appointment = current_patient.appointments.not_checked_in.current
      raise CannotCancelAndReschedule if appointment && !appointment.can_cancel_and_reschedule?

      appointment
    end

    def from
      Rails.configuration.x.schedule_from_hours.hours.from_now
    end

    def to
      Rails.configuration.x.schedule_up_to_days.days.from_now.end_of_day
    end

    def scheduler
      AppointmentScheduler.new(earliest_allowed: from, latest_allowed: to)
    end

    def message_for(result, appointment:, desired_start:)
      case result
      when AppointmentScheduler::CONDITIONS_UNMET
        {
          alert: 'Você não está entre grupos que podem fazer agendamentos.',
          cy: 'appointmentSchedulerConditionsUnmetAlertText'
        }
      when AppointmentScheduler::NO_SLOTS
        {
          alert: 'Desculpe, mas não foi possível agendar devido a disponibilidade da vaga. Tente novamente.'
        }
      when AppointmentScheduler::SUCCESS
        {
          notice: success_message(desired_start, appointment.start)
        }
      else
        raise "Unexpected result #{result}"
      end
    end

    def success_message(desired_date, scheduled_date)
      if desired_date.present? && (desired_date - scheduled_date).abs > AppointmentScheduler::ROUNDING
        'Vacinação agendada, porém em horário diferente dado que o desejado já encontrava-se agendado. ' \
          "O horário mais próximo disponível foi #{I18n.l scheduled_date, format: :short}."
      else
        'Vacinação agendada.'
      end
    end

    # Loads pages for the Index, between 0 and max possible allowed
    def parse_days
      [
        [
          0,
          params[:page].presence&.to_i || scheduler.days_ahead_with_open_slot
        ].compact.max,
        Rails.configuration.x.schedule_up_to_days
      ].min
    end

    # rubocop:disable Rails/Date (as we're generating the string it with timezone)
    def parse_start
      create_params[:start].present? && create_params[:start]&.to_time
    rescue ArgumentError
      nil
    end

    # rubocop:enable Rails/Date

    def create_params
      params.require(:appointment).permit(:ubs_id, :start)
    end

    def slot_params
      params.permit(:gap_in_days)
    end
  end
end
