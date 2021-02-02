class UbsController < UserSessionController
  before_action :set_ubs

  def active_hours
    @appointments = active_future_appointments
  end

  def index
    @appointments = future_appointments.where.not(patient_id: nil).order(start: :asc)
    @bedridden_patients = @ubs.bedridden_patients
  end

  def confirm_check_in
    appointment = Appointment.find(params[:id])

    ReceptionService.new(appointment.patient).check_in

    redirect_to ubs_patient_details_path(id: appointment.id, check_in: true)
  end

  def confirm_check_out
    appointment = Appointment.find(params[:id])
    patient = appointment.patient

    ReceptionService.new(patient).check_out

    @second_dose_appointment = patient.reload.last_appointment

    redirect_to ubs_patient_details_path(id: appointment.id, second_dose_appointment: @second_dose_appointment, check_out: true)
  end

  def find_patients
    @cpf = params['cpf']
    @name = params['name']

    if @cpf.present?
      @patients = Patient.where(cpf: @cpf)

      @appointments_patients = build_appointments_patients(@patients)
    elsif @name.present?
      @patients = Patient.where('name ~* ?', @name)

      @appointments_patients = build_appointments_patients(@patients)
    end

    render 'ubs/checkin'
  end

  def checkout
    now = Time.zone.now

    patients_ids = Appointment.where.not(check_in: nil).where(check_out: nil, start: now.beginning_of_day..now.end_of_day).pluck(:patient_id)
    @patients = Patient.find(patients_ids)

    @appointments_patients = build_appointments_patients(@patients, check_out: true)

    render 'ubs/checkout'
  end

  def patient_details
    @appointment = Appointment.find(params[:id])
    @second_dose_appointment = Appointment.find(params[:second_dose_appointment]) if params[:second_dose_appointment]
    @check_out = params[:check_out]
    @check_in = params[:check_in]

    patient = @appointment.patient

    groups = []
    Patient::CONDITIONS.each do |cond, func|
      groups << cond if func.call(patient)
    end

    @patient = {
      id: patient.id,
      name: patient.name,
      cpf: patient.cpf,
      groups: groups
    }

    render ubs_patient_details_path
  end

  def today_appointments
    @appointments = @ubs.appointments.today.order(:start)

    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] =
          "attachment; filename=\"agendamentos_#{Date.current}.xlsx\""
      }
    end
  end

  def activate_ubs
    updated = @ubs.update(active: true)

    return redirect_to ubs_index_path if updated
  end

  def deactivate_ubs
    updated = @ubs.update(active: false)

    return redirect_to ubs_index_path if updated
  end

  def change_active_hours
    shift_start_tod = Tod::TimeOfDay.parse(active_hour_for_attr('shift_start_date'))
    break_start_tod = Tod::TimeOfDay.parse(active_hour_for_attr('break_start_date'))
    break_end_tod = Tod::TimeOfDay.parse(active_hour_for_attr('break_end_date'))
    shift_end_tod = Tod::TimeOfDay.parse(active_hour_for_attr('shift_end_date'))

    shift_start_sat_tod = Tod::TimeOfDay.parse(active_hour_for_attr('shift_start_saturday'))
    break_start_sat_tod = Tod::TimeOfDay.parse(active_hour_for_attr('break_start_saturday'))
    break_end_sat_tod = Tod::TimeOfDay.parse(active_hour_for_attr('break_end_saturday'))
    shift_end_sat_tod = Tod::TimeOfDay.parse(active_hour_for_attr('shift_end_saturday'))

    open_on_saturday = active_hours_params['open_saturday'].to_i == 1

    updated = @ubs.update(
      shift_start: shift_start_tod.to_s,
      break_start: break_start_tod.to_s,
      break_end: break_end_tod.to_s,
      shift_end: shift_end_tod.to_s,
      open_saturday: open_on_saturday,
      saturday_shift_start: shift_start_sat_tod.to_s,
      saturday_break_start: break_start_sat_tod.to_s,
      saturday_break_end: break_end_sat_tod.to_s,
      saturday_shift_end: shift_end_sat_tod.to_s
    )

    return redirect_to ubs_index_path if updated

    render ubs_active_hours_path
  end

  def slot_duration
    @appointments = active_future_appointments
  end

  def change_slot_duration
    updated = @ubs.update(slot_duration_params)

    return redirect_to ubs_index_path if updated

    render ubs_slot_duration_path
  end

  def suspend_appointment
    appointment = @ubs.appointments.find(params[:id])

    appointment.update(active: false, suspend_reason: params[:reason])

    redirect_to ubs_patient_details_path(ubs_id: @ubs.id, id: appointment.id)
  end

  def activate_appointment
    appointment = @ubs.appointments.find(params[:id])

    appointment.update(active: true)

    redirect_to ubs_index_path
  end

  def cancel_all_future_appointments
    appointments = future_appointments

    appointments.update_all(active: false)

    redirect_to ubs_index_path
  end

  def activate_all_future_appointments
    appointments = @ubs.appointments.where(
      'start >= ? AND active = ?', Time.zone.now - @ubs.slot_interval_minutes * 60, false
    )

    appointments.update_all(active: true)

    redirect_to ubs_index_path
  end

  private

  def build_appointments_patients(patients, check_out: false)
    appointments_patients = []

    # FIXME: Should we reduce the scope of this search to improve performance?
    if check_out
      appointments = Appointment.where(
        patient_id: patients.map(&:id),
      ).where.not(check_in: nil)
    else
      appointments = Appointment.where(
        patient_id: patients.map(&:id),
        check_in: nil
      )
    end

    return [] unless appointments.any?

    appointments.each do |appointment|
      patient = appointment.patient

      appointments_patients << {
        id: appointment.id,
        name: patient.name,
        cpf: patient.cpf,
        start: appointment.start,
        time_delta: (appointment[:start] - Time.zone.now).abs,
        active: appointment.active
      }
    end

    appointments_patients = appointments_patients.sort_by { |appointment| appointment[:time_delta] }

    appointments_patients
  end

  def active_future_appointments
    @future_appointments = @ubs.appointments.where(
      'start >= ? AND active = ?', Time.zone.now, true
    )
  end

  def future_appointments
    @future_appointments = @ubs.appointments.where(
      'start >= ?', Time.zone.now - @ubs.slot_interval_minutes * 60
    )
  end

  def active_hour_for_attr(attr_name)
    "#{active_hours_params[attr_name + '(4i)']}:#{active_hours_params[attr_name + '(5i)']}"
  end

  def set_ubs
    @ubs = Ubs.find_by(user: current_user)
  end

  def active_hours_params
    params.require(:ubs).permit(:shift_start_date, :shift_end_date, :break_start_date, :break_end_date,
                                :shift_start_saturday, :break_start_saturday, :break_end_saturday,
                                :shift_end_saturday, :open_saturday)
  end

  def slot_duration_params
    params.require(:ubs).permit(:slot_interval_minutes, :appointments_per_time_slot)
  end

end
