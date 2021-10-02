module Admin
  class AppointmentsController < Base
    before_action :set_appointment, only: %i[show check_in undo_check_in check_out undo_check_out suspend activate remove_patient]
    skip_before_action :require_administrator!,
                       only: %i[index show new create check_in undo_check_in check_out undo_check_out suspend activate
                                remove_patient]
    helper_method :ubs_index

    # rubocop:disable Metrics/AbcSize
    def index
      @ubs = ubs_index.one? ? ubs_index.first : ubs_index.find_by(id: index_params[:ubs_id])
      @date = date_from_params params, :date
      @date ||= Time.zone.today

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

    def new
      @appointment = Appointment.new(patient_id: params[:patient_id])
    end

    # Create appointment and vaccinate patient in a single go
    # rubocop:disable Metrics/AbcSize
    def create
      Appointment.isolated_transaction do
        @appointment = Appointment.new(create_params)
        @appointment.end = @appointment.start + @appointment.ubs.slot_interval_minutes.minutes
        vaccine = Vaccine.find_by id: params[:vaccine_id]
        last_dose = @appointment.patient.doses.order(:sequence_number).last
        patient = @appointment.patient

        if @appointment.patient.doses.exists? && @appointment.save
          create_booster_dose(@appointment, vaccine, patient, last_dose)

          redirect_to([:admin, @appointment])

        elsif vaccine && @appointment.save
          ReceptionService.new(@appointment).tap do |service|
            service.check_in(at: @appointment.start)
            service.check_out(vaccine, at: @appointment.start)
          end

          redirect_to([:admin, @appointment])
        else
          render :new
        end
      end
    end
    # rubocop:enable Metrics/AbcSize

    def check_in
      unless @appointment.can_check_in?
        return redirect_to admin_appointment_path(@appointment, return_to: return_to),
                           flash: { error: t(:'appointments.messages.cannot_check_in') }
      end

      ReceptionService.new(@appointment).check_in

      redirect_to admin_appointment_path(@appointment, return_to: return_to),
                  flash: { notice: t(:'appointments.messages.checked_in', name: @appointment.patient.name) }
    end

    def undo_check_in
      unless @appointment.can_undo_check_in?
        return redirect_to admin_appointment_path(@appointment, return_to: return_to),
                           flash: { error: t(:'appointments.messages.cannot_undo_check_in') }
      end

      ReceptionService.new(@appointment).undo_check_in

      redirect_to admin_appointment_path(@appointment, return_to: return_to),
                  flash: { notice: t(:'appointments.messages.undid_check_in', name: @appointment.patient.name) }
    end

    def check_out
      unless @appointment.can_check_out?
        return redirect_to admin_appointment_path(@appointment, return_to: return_to),
                           flash: { error: t(:'appointments.messages.cannot_check_out') }
      end

      vaccine = Vaccine.find_by id: params[:vaccine_id]

      unless vaccine
        return redirect_to(admin_appointment_path(@appointment, return_to: return_to),
                           flash: { error: 'Selecione a vacina aplicada.' })
      end

      checked_out = ReceptionService.new(@appointment).check_out(vaccine)

      redirect_to admin_appointment_path(@appointment, return_to: return_to),
                  flash: { notice_title: notice_for_checked_out(checked_out, @appointment) }
    end

    def undo_check_out
      unless @appointment.can_undo_check_out?
        return redirect_to admin_appointment_path(@appointment, return_to: return_to),
                           flash: { error: t(:'appointments.messages.cannot_undo_check_out') }
      end

      ReceptionService.new(@appointment).undo_check_out

      redirect_to admin_appointment_path(@appointment, return_to: return_to),
                  flash: { notice: t(:'appointments.messages.undid_check_out', name: @appointment.patient.name) }
    end

    def suspend
      unless @appointment.can_suspend?
        return redirect_to admin_appointment_path(@appointment, return_to: return_to),
                           flash: { error: t(:'appointments.messages.cannot_suspend') }
      end

      @appointment.update!(active: false, suspend_reason: params[:appointment][:suspend_reason])

      redirect_to admin_appointment_path(@appointment, return_to: return_to),
                  flash: { notice: t(:'appointments.messages.suspended', name: @appointment.patient.name) }
    end

    def activate
      unless @appointment.can_activate?
        return redirect_to admin_appointment_path(@appointment, return_to: return_to),
                           flash: { error: t(:'appointments.messages.cannot_activate') }
      end

      @appointment.update!(active: true, suspend_reason: nil)

      redirect_to admin_appointment_path(@appointment, return_to: return_to),
                  flash: { notice: t(:'appointments.messages.activated', name: @appointment.patient.name) }
    end

    def remove_patient
      unless @appointment.can_remove_patient?
        return redirect_to admin_appointment_path(@appointment, return_to: return_to),
                           flash: { error: t(:'appointments.messages.cannot_remove_patient') }
      end

      @appointment.update!(patient_id: nil)

      redirect_to admin_appointment_path(@appointment, return_to: return_to),
                  flash: { notice: t(:'appointments.messages.removed_patient') }
    end

    private

    def index_params
      params.permit(:page, :ubs_id, :date, :per_page)
    end

    def create_params
      params.require(:appointment).permit(:patient_id, :ubs_id, :start, :end)
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

    def create_booster_dose(appointment, vaccine, patient, last_dose)
      last_dose.update!(follow_up_appointment: appointment)

      appointment.update!(check_in: appointment.start, check_out: appointment.end)

      Dose.create!(patient: patient,
                   vaccine: vaccine,
                   sequence_number: last_dose.next_sequence_number,
                   appointment: appointment)
    end

    def ubs_index
      @ubs_index ||= current_user.admin? ? Ubs.order(:name) : current_user.ubs.order(:name)
    end
  end
end
