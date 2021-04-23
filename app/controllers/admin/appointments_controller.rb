module Admin
  class AppointmentsController < Base
    before_action :set_appointment, only: %i[show]

    def index
      @ubs = Ubs.find_by(id: index_params[:ubs_id])
      @date = date_from_params params, :date
      @date ||= Time.zone.today

      @appoitments = Appointment
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

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # TODO: move elsewhere [jmonteiro]
    def date_from_params(params, date_key)
      date_keys = params.keys.select { |k| k.to_s.match?(date_key.to_s) }.sort
      return nil if date_keys.empty?

      date_array = params.values_at(*date_keys).map(&:to_i)
      Date.civil(*date_array)
    end
  end
end
