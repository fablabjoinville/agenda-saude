module Operator
  class AppointmentsController < Base
    FILTERS = {
      search: 'search',
      all: 'all',
      waiting: 'waiting',
      checked_in: 'checked_in',
      checked_out: 'checked_out'
    }.freeze

    # rubocop:disable Metrics/AbcSize
    def index
      appointments = @ubs.appointments
                         .today
                         .scheduled
                         .includes(:patient)
                         .order(:start)

      @appointments = filter(search(appointments))
                      .order(:start)
                      .joins(:patient)
                      .order(Patient.arel_table[:name].lower.asc)
                      .page(index_params[:page])
                      .per([[10, index_params[:per_page].to_i].max, 10_000].min) # max of 10k is for exporting to XLS

      respond_to do |format|
        format.html
        format.xlsx do
          response.headers['Content-Disposition'] = "attachment; filename=\"vacina_agendamentos_#{Date.current}.xlsx\""
        end
      end
    end
    # rubocop:enable Metrics/AbcSize

    def show
      @appointment = @ubs.appointments.scheduled.find(params[:id])

      @other_appointments = @appointment.patient.appointments.where.not(id: @appointment.id)

      @doses = @appointment.patient.doses.includes(:vaccine, appointment: [:ubs])
    end

    # Check-in single appointment
    def check_in
      appointment = @ubs.appointments.scheduled.not_checked_in.find(params[:id])
      unless appointment.in_allowed_check_in_window?
        return redirect_to(operator_appointment_path(appointment),
                           flash: { alert: t(:"appointments.messages.not_allowed_window") })
      end

      ReceptionService.new(appointment).check_in

      redirect_to operator_appointments_path, flash: { notice: "Check-in realizado para #{appointment.patient.name}." }
    end

    # Check-out single appointment
    # rubocop:disable Metrics/AbcSize
    def check_out
      appointment = @ubs.appointments.scheduled.not_checked_out.find(params[:id])
      vaccine_name = appointment.vaccine_name.presence || check_out_params[:appointment].try(:[], :vaccine_name)

      return redirect_to(operator_appointment_path(appointment), flash: { error: 'Selecione vacina.' }) if vaccine_name.blank?

      # next appointment
      next_appointment = ReceptionService.new(appointment).check_out(vaccine_name)

      redirect_to operator_appointment_path(appointment),
                  flash: {
                    notice_title: if next_appointment
                                    "#{next_appointment.patient.name} tomou primeira dose e está com segunda dose " \
                                    "agendada para #{I18n.l next_appointment.start, format: :human} na unidade " \
                                    " #{next_appointment.ubs.name}"
                                  else
                                    appointment.patient.vaccinated?
                                    "#{appointment.patient.name} está imunizada(o) com duas doses."
                                  end
                  }
    end
    # rubocop:enable Metrics/AbcSize

    # Suspend single appointment
    def suspend
      appointment = @ubs.appointments.scheduled.not_checked_in.find(params[:id])
      appointment.update!(active: false, suspend_reason: params[:appointment][:suspend_reason])

      redirect_to operator_appointments_path,
                  flash: {
                    notice: "Agendamento suspenso para #{appointment.patient.name}"
                  }
    end

    # Activate (un-suspend) single appointment
    def activate
      appointment = @ubs.appointments.scheduled.find(params[:id])
      appointment.update!(active: true, suspend_reason: nil)

      redirect_to operator_appointment_path(appointment),
                  flash: {
                    notice: "Agendamento reativado para #{appointment.patient.name}."
                  }
    end

    private

    # Filters out appointments
    def filter(appointments)
      # use @filter from search, or input from param (permit-listed), or set to default "waiting"
      @filter ||= (FILTERS.values & [index_params[:filter].to_s]).presence&.first || FILTERS[:waiting]

      case @filter
      when FILTERS[:waiting]
        appointments.not_checked_in.not_checked_out
      when FILTERS[:checked_in]
        appointments.checked_in.not_checked_out
      when FILTERS[:checked_out]
        appointments.checked_in.checked_out
      else
        appointments
      end
    end

    # Searches for specific appointments
    def search(appointments)
      if index_params[:search].present? && index_params[:search].size >= 3
        @filter = FILTERS[:search] # In case we're searching, use special filter
        @search = index_params[:search]
        return appointments.search_for(@search)
      end

      appointments
    end

    def check_out_params
      params.permit(appointment: [:vaccine_name])
    end

    def index_params
      params.permit(:per_page, :page, :search, :filter)
    end
  end
end
