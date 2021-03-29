module Community
  class AppointmentsController < Base
    def home
      return redirect_to(vaccinated_community_appointments_path) if current_patient.vaccinated?

      @appointment = current_patient.appointments.not_checked_in.current

      return if @appointment

      return unless current_patient.can_schedule?

      @appointments_count = Appointment.active_ubs
                                       .open
                                       .not_scheduled
                                       .count
    end

    # Reschedules appointment (only if patient already has one scheduled)
    def index
      if Rails.configuration.x.disabled_reschedule_toggle.present?
        return redirect_to(home_community_appointments_path,
                           flash: { alert: I18n.t(:'alerts.patient_disabled_reschedule') })
      end

      @appointment = current_patient.appointments.not_checked_in.current
      return redirect_to(home_community_appointments_path) unless @appointment

      @days = parse_days
      @appointments = scheduler.open_times_per_ubs(from: @days.days.from_now.beginning_of_day,
                                                   to: @days.days.from_now.end_of_day)
    rescue AppointmentScheduler::NoFreeSlotsAhead
      redirect_to home_community_appointments_path, flash: { alert: 'Não há vagas disponíveis para reagendamento.' }
    end

    def create
      result, new_appointment = scheduler.schedule(
        patient: current_patient,
        ubs_id: params[:ubs_id].presence,
        from: parse_start
      )

      redirect_to home_community_appointments_path,
                  flash: message_for(result, appointment: new_appointment, desired_start: parse_start)
    end

    def destroy
      scheduler.cancel_schedule(patient: current_patient, id: params[:id])

      redirect_to home_community_appointments_path
    end

    def vaccinated
      return redirect_to(home_community_appointments_path) unless current_patient.vaccinated?

      appointments = current_patient.appointments.active.checked_out.order(:check_out).limit(2).all
      @first_dose_appointment = appointments.first
      @second_dose_appointment = appointments.last
    end

    private

    def scheduler
      AppointmentScheduler.new(
        earliest_allowed: Rails.configuration.x.schedule_from_hours.hours.from_now,
        latest_allowed: Rails.configuration.x.schedule_up_to_days.days.from_now.end_of_day
      )
    end

    def message_for(result, appointment:, desired_start:)
      case result
      when AppointmentScheduler::CONDITIONS_UNMET
        {
          alert: 'Você não está entre grupos que podem fazer agendamentos.'
        }
      when AppointmentScheduler::NO_SLOTS
        {
          alert: 'Desculpe, mas não há mais vagas disponíveis. Tente novamente mais tarde.'
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
      create_params[:appointment]&.key?(:start) && create_params[:appointment][:start]&.to_time
    rescue ArgumentError
      nil
    end

    # rubocop:enable Rails/Date

    def create_params
      params.permit(appointment: %i[ubs_id start])
    end

    def slot_params
      params.permit(:gap_in_days)
    end
  end
end
