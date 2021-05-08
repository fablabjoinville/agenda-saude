module Admin
  class AppointmentsController < Base
    before_action :set_appointment, only: %i[show]

    def index
      @ubs = Ubs.find_by(id: index_params[:ubs_id])
      @date = date_from_params params, :date
      @date ||= Time.zone.today

      @appoitments = Appointment
                     .includes(:dose)
                     .includes(:patient)
                     .where(ubs_id: index_params[:ubs_id], start: @date.beginning_of_day..@date.end_of_day)
                     .order(:start, :id)
                     .page(index_params[:page])
                     .per(100)
    end

    def show; end

    private

    def index_params
      params.permit(:page, :ubs_id, :date)
    end

    def appointments_bulk_params
      params.require(:appointments_bulk).permit(:from, :to, :ubs_ids)
    end

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end
  end
end
