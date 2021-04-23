module Admin
  class AppointmentsController < Base
    def index
      if index_params[:date].is_a? Hash
        @date = Date.iso8601 [index_params[:date][1], index_params[:date][2].to_s.rjust(2, '0'),
                              index_params[:date][3].to_s.rjust(2, '0')].join('-')
      end

      @date ||= Date.today

      @appoitments = Appointment.where(ubs_id: index_params[:ubs_id], start: @date.beginning_of_day..@date.end_of_day)
    end

    private

    def index_params
      params.permit(:ubs_id, date: %i[day month year])
    end
  end
end
