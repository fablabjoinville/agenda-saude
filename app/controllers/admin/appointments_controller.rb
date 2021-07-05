module Admin
  class AppointmentsController < Base
    before_action :set_appointment, only: %i[show check_in undo_check_in check_out undo_check_out suspend activate remove_patient]
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

    def check_in
      unless @appointment.can_check_in?
        return redirect_to [:admin, @appointment.patient],
                           flash: { error: t(:'appointments.messages.cannot_check_in') }
      end

      ReceptionService.new(@appointment).check_in

      redirect_to [:admin, @appointment.patient],
                  flash: { notice: t(:'appointments.messages.checked_in', name: @appointment.patient.name) }
    end

    def undo_check_in
      unless @appointment.can_undo_check_in?
        return redirect_to [:admin, @appointment.patient],
                           flash: { error: t(:'appointments.messages.cannot_undo_check_in') }
      end

      ReceptionService.new(@appointment).undo_check_in

      redirect_to [:admin, @appointment.patient],
                  flash: { notice: t(:'appointments.messages.undid_check_in', name: @appointment.patient.name) }
    end

    def check_out
      unless @appointment.can_check_out?
        return redirect_to [:admin, @appointment.patient],
                           flash: { error: t(:'appointments.messages.cannot_check_out') }
      end

      vaccine = Vaccine.find_by id: params[:vaccine_id]

      unless vaccine
        return redirect_to([:admin, @appointment.patient],
                           flash: { error: 'Selecione a vacina aplicada.' })
      end

      checked_out = ReceptionService.new(@appointment).check_out(vaccine)

      redirect_to [:admin, @appointment.patient],
                  flash: { notice_title: notice_for_checked_out(checked_out, @appointment) }
    end

    def undo_check_out
      unless @appointment.can_undo_check_out?
        return redirect_to [:admin, @appointment.patient],
                           flash: { error: t(:'appointments.messages.cannot_undo_check_out') }
      end

      ReceptionService.new(@appointment).undo_check_out

      redirect_to [:admin, @appointment.patient],
                  flash: { notice: t(:'appointments.messages.undid_check_out', name: @appointment.patient.name) }
    end

    def suspend
      unless @appointment.can_suspend?
        return redirect_to [:admin, @appointment.patient],
                           flash: { error: t(:'appointments.messages.cannot_suspend') }
      end

      @appointment.update!(active: false, suspend_reason: params[:appointment][:suspend_reason])

      redirect_to [:admin, @appointment.patient],
                  flash: { notice: t(:'appointments.messages.suspended', name: @appointment.patient.name) }
    end

    def activate
      unless @appointment.can_activate?
        return redirect_to [:admin, @appointment.patient],
                           flash: { error: t(:'appointments.messages.cannot_activate') }
      end

      @appointment.update!(active: true, suspend_reason: nil)

      redirect_to [:admin, @appointment.patient],
                  flash: { notice: t(:'appointments.messages.activated', name: @appointment.patient.name) }
    end

    def remove_patient
      unless @appointment.can_remove_patient?
        return redirect_to [:admin, @appointment.patient],
                           flash: { error: t(:'appointments.messages.cannot_remove_patient') }
      end

      @appointment.update!(patient_id: nil)

      redirect_to [:admin, @appointment.patient],
                  flash: { notice: t(:'appointments.messages.removed_patient') }
    end

    private

    def index_params
      params.permit(:page, :ubs_id, :date, :per_page)
    end

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def notice_for_checked_out(checked_out, appointment)
      if checked_out.dose.follow_up_appointment
        I18n.t('alerts.dose_received_with_follow_up',
               name: appointment.patient.name,
               sequence_number: checked_out.dose.sequence_number,
               date: I18n.l(checked_out.next_appointment.start, format: :human))
      else
        I18n.t('alerts.last_dose_received', name: appointment.patient.name)
      end
    end
  end
end
