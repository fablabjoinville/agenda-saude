module Community
  class AppointmentsController < Base
    class NoFreeAppointments < StandardError; end

    ROUNDING = 2.minutes # delta to avoid rounding issues

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
      @appointment = current_patient.appointments.not_checked_in.current
      return redirect_to(home_community_appointments_path) unless @appointment

      @days = parse_days
      from = [
        @days.days.from_now.beginning_of_day,
        Rails.configuration.x.schedule_from_hours.hours.from_now
      ].max
      to = @days.days.from_now.end_of_day

      @appointments = Appointment.active_ubs
                                 .active
                                 .not_scheduled
                                 .open
                                 .where(start: from..to)
                                 .order(:start) # in chronological order
                                 .select(:ubs_id, :start, :end) # only return what we care with
                                 .distinct # remove duplicates (same as .uniq in pure Ruby)
                                 .group_by(&:ubs) # transforms it into a Hash grouped by Ubs
    rescue NoFreeAppointments
      redirect_to home_community_appointments_path, flash: { alert: 'Não há vagas disponíveis para reagendamento.' }
    end

    def create
      start = [
        Rails.configuration.x.schedule_from_hours.hours.from_now,
        parse_start
      ].compact.max - ROUNDING

      result, data = AppointmentScheduler.new.schedule(
        patient: current_patient,
        ubs_id: params[:ubs_id].presence,
        start: start..(Rails.configuration.x.schedule_up_to_days.days.from_now.end_of_day)
      )

      case result
      when AppointmentScheduler::CONDITIONS_UNMET
        redirect_to home_community_appointments_path, flash: {
          alert: 'Você não está entre grupos que podem fazer agendamentos.'
        }
      when AppointmentScheduler::NO_SLOTS
        redirect_to home_community_appointments_path, flash: {
          alert: 'Desculpe, mas não há mais vagas disponíveis. Tente novamente mais tarde.'
        }
      when AppointmentScheduler::SUCCESS
        notice = if (start - data.start).abs > ROUNDING
                   "O primeiro horário disponível para agendamento foi #{I18n.l data.start, format: :short}."
                 else
                   'Vacinação agendada para o horário desejado.'
                 end

        redirect_to home_community_appointments_path, flash: {
          notice: notice
        }
      else
        notify_unexpected_result(result: result, data: data, context: context)
        redirect_to home_community_appointments_path, flash: {
          alert: 'Ocorreu um erro inesperado, tente novamente mais tarde.'
        }
      end
    end

    def destroy
      current_patient.appointments
                     .open
                     .where(id: params[:id])
                     .update_all(patient_id: nil)

      redirect_to home_community_appointments_path
    end

    def vaccinated
      return redirect_to(home_community_appointments_path) unless current_patient.vaccinated?

      appointments = current_patient.appointments.active.checked_out.order(:check_out).limit(2).all
      @first_dose_appointment = appointments.first
      @second_dose_appointment = appointments.last
    end

    private

    # Loads pages for the Index, between 0 and max possible allowed
    def parse_days
      [
        [
          0,
          params[:page].presence&.to_i || open_not_scheduled_appointment_days_ahead
        ].compact.max,
        Rails.configuration.x.schedule_up_to_days
      ].min
    end

    # Returns how many days ahead there are available appointments
    def open_not_scheduled_appointment_days_ahead
      from = Rails.configuration.x.schedule_from_hours.hours.from_now
      to = Rails.configuration.x.schedule_up_to_days.days.from_now.end_of_day

      next_available_appointment = Appointment.active_ubs
                                              .open
                                              .not_scheduled
                                              .where(start: from..to)
                                              .order(:start)
                                              .pick(:start)

      raise NoFreeAppointments unless next_available_appointment

      ((next_available_appointment - Time.zone.now.end_of_day) / 1.day).ceil
    end

    def parse_start
      create_params[:appointment]&.key?(:start) && create_params[:appointment][:start]&.to_time
    rescue ArgumentError
      nil
    end

    def create_params
      params.permit(appointment: %i[ubs_id start])
    end

    def slot_params
      params.permit(:gap_in_days)
    end
  end
end
