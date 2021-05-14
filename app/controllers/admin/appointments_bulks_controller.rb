module Admin
  class AppointmentsBulksController < Base
    def new
      @appointments_bulk = AppointmentsBulk.new from: Time.zone.now.to_date, to: 1.week.from_now.to_date,
                                                ubs_ids: [], active: true
    end

    def create
      @appointments_bulk = AppointmentsBulk.new appointments_bulk_params

      flash.now[:notice] = 'Agendamentos criados.' if @appointments_bulk.save

      render :new
    end

    private

    def appointments_bulk_params
      params.require(:appointments_bulk).permit(:from, :to, :active, ubs_ids: [])
    end
  end
end
