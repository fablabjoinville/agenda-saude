module Admin
  class AppointmentsController < Base
    before_action :set_appointment, only: %i[show]
    skip_before_action :require_administrator!, only: %i[index show]

    # rubocop:disable Metrics/AbcSize
    def index
      @ubs_index = current_user.admin? ? Ubs.order(:name) : current_user.ubs.order(:name)
      @ubs = @ubs_index.one? ? @ubs_index.first : @ubs_index.find_by(id: index_params[:ubs_id])
      @date = date_from_params params, :date
      @date ||= Time.zone.today
      @vaccines = Vaccine.all

      @appointments = Appointment
                      .includes(dose: :vaccine)
                      .includes(:follow_up_for_dose)
                      .includes(:patient)
                      .where(ubs: @ubs, start: @date.all_day)
                      .order(:start, :id)
                      .page(index_params[:page])
                      .per(10_000)
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
