module Operator
  class AppointmentsController < Base
    FILTERS = {
      search: 'search',
      all: 'all',
      waiting: 'waiting',
      checked_in: 'checked_in',
      checked_out: 'checked_out'
    }.freeze

    def index
      @filter = (FILTERS.values & [index_params[:filter].to_s]).presence&.first || FILTERS[:waiting]

      appointments = @ubs.appointments
                         .today
                         .scheduled
                         .includes(:patient)
                         .order(:start)

      if index_params[:search].present? && index_params[:search].size >= 3
        @search = index_params[:search]
        appointments = appointments.search_for(@search)
        @filter = FILTERS[:search] # In case we're searching, move filter to all
      end

      case @filter
      when FILTERS[:waiting]
        appointments = appointments.not_checked_in.not_checked_out
      when FILTERS[:checked_in]
        appointments = appointments.checked_in.not_checked_out
      when FILTERS[:checked_out]
        appointments = appointments.checked_in.checked_out
      end

      @appointments = appointments
                      .page(index_params[:page])
                      .per([[10, index_params[:per_page].to_i].max, 10_000].min) # max of 10k is for allowing exporting to XLS

      respond_to do |format|
        format.html
        format.xlsx do
          response.headers['Content-Disposition'] = "attachment; filename=\"vacina_agendamentos_#{Date.current}.xlsx\""
        end
      end
    end

    def index_params
      params.permit(:per_page, :page, :search, :filter)
    end

    def show
      @appointment = @ubs.appointments.scheduled.find(params[:id])

      @other_appointments = @appointment.patient.appointments.where.not(id: @appointment.id)
    end

    # Check-in single appointment
    def check_in
      appointment = @ubs.appointments.scheduled.not_checked_in.find(params[:id])
      unless appointment.in_allowed_check_in_window?
        return redirect_to(operator_appointment_path(appointment),
                           flash: { alert: t(:"appointments.messages.not_allowed_window") })
      end

      ReceptionService.new(appointment).check_in

      redirect_to operator_appointment_path(appointment)
    end

    # Check-out single appointment
    def check_out
      appointment = @ubs.appointments.scheduled.not_checked_out.find(params[:id])
      vaccine_name = appointment.vaccine_name.presence || check_out_params[:vaccine_name]

      # next appointment
      next_appointment = ReceptionService.new(appointment).check_out(vaccine_name)

      redirect_to operator_appointment_path(appointment), flash: {
        notice: if next_appointment.patient.vaccinated?
                  "#{next_appointment.patient.name} está imunizada(o) com duas doses."
                else
                  "#{next_appointment.patient.name} tomou primeira dose e está com segunda dose agendada para " \
                   "#{I18n.l next_appointment.start, format: :human}"
                end
      }
    end

    # Suspend single appointment
    def suspend
      appointment = @ubs.appointments.scheduled.not_checked_in.find(params[:id])
      appointment.update!(active: false, suspend_reason: params[:reason])

      redirect_to operator_appointment_path(appointment)
    end

    # Activate (un-suspend) single appointment
    def activate
      appointment = @ubs.appointments.scheduled.find(params[:id])
      appointment.update!(active: true, suspend_reason: nil)

      redirect_to operator_appointment_path(appointment), flash: { notice: 'Agendamento reativado.' }
    end

    # Suspends all future appointments
    def suspend_future
      @ubs.appointments
          .not_checked_in
          .not_checked_out
          .active
          .future
          .update_all(active: false)

      redirect_to operator_appointments_path
    end

    # Reactivate all future appointments
    def activate_future
      @ubs.appointments
          .not_checked_in
          .not_checked_out
          .suspended
          .future
          .update_all(active: true)

      redirect_to operator_appointments_path
    end

    private

    def check_out_params
      params.require(:appointment).permit(:vaccine_name)
    end
  end
end
