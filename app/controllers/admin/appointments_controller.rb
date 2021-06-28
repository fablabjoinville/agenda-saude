module Admin
  class AppointmentsController < Base
    before_action :set_appointment, only: %i[show check_in check_out suspend activate remove_patient]
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

    def new; end # TODO

    def create; end # TODO

    def show; end

    # Check-in single appointment
    def check_in
      ReceptionService.new(@appointment).check_in

      redirect_to [:admin, @appointment]
    end

    def undo_check_in
      ReceptionService.new(@appointment).undo_check_in

      redirect_to [:admin, @appointment]
    end

    # Check-out single appointment
    def check_out
      vaccine = Vaccine.find_by id: check_out_params[:vaccine_id]

      unless vaccine
        return redirect_to([:admin, @appointment],
                           flash: { error: 'Selecione a vacina aplicada.' })
      end

      checked_out = ReceptionService.new(@appointment).check_out(vaccine)

      redirect_to([:admin, @appointment])
    end

    def undo_check_out
      ReceptionService.new(@appointment).undo_check_out

      redirect_to [:admin, @appointment]
    end

    # Suspend single appointment
    def suspend
      @appointment.update!(active: false, suspend_reason: params[:appointment][:suspend_reason])

      redirect_to([:admin, @appointment])
    end

    # Activate (un-suspend) single appointment
    def activate
      @appointment.update!(active: true, suspend_reason: nil)

      redirect_to([:admin, @appointment])
    end

    def assign
      raise "TODO"
    end

    def unassign
      ReceptionService.new(@appointment).undo_check_in # will also undo check out
      @appointment.update! patient_id: nil

      redirect_to([:admin, @appointment])
    end

    private

    def index_params
      params.permit(:page, :ubs_id, :date, :per_page)
    end

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end
  end
end
