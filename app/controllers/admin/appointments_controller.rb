module Admin
  class AppointmentsController < Base
    before_action :set_appointment, only: %i[show]

    # rubocop:disable Metrics/AbcSize
    def index
      @per_page = index_params[:per_page].presence&.to_i || 100
      @ubs = Ubs.find_by(id: index_params[:ubs_id])
      @date = date_from_params params, :date
      @date ||= Time.zone.today
      @vaccines = Vaccine.all

      @appoitments = Appointment
                     .includes(dose: :vaccine)
                     .includes(:follow_up_for_dose)
                     .includes(:patient)
                     .where(ubs_id: index_params[:ubs_id], start: @date.beginning_of_day..@date.end_of_day)
                     .order(:start, :id)
                     .page(index_params[:page])
                     .per(@per_page)
    end
    # rubocop:enable Metrics/AbcSize

    def show; end

    private

    def index_params
      params.permit(:page, :ubs_id, :date, :per_page)
    end

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end
  end
end
