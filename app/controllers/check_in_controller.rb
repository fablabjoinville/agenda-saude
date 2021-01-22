class CheckInController < UserSessionController
  def search
    @ubs = Ubs.find(params[:ubs_id])

    render 'ubs/check_in/index'
  end

  def find_patients
    @ubs = Ubs.find(params[:ubs_id])

    if params[:patient][:cpf].present?
      @patients = Patient.where(cpf: params[:patient][:cpf])
    elsif params[:patient][:name].present?
      @patients = Patient.where(name: params[:patient][:name])
    end

    render 'ubs/check_in/found_patients'
  end

  def patient_details
    @patient = Patient.find(params[:patient_id])
    @appointments = Appointment.where(patient_id: @patient.id)

    render 'ubs/check_in/patient_details'
  end

  def confirm_check_in
    @patient = Patient.find(params[:patient_id])
    @appointments = Appointment.where(patient_id: @patient.id)

    @appointments&.last.update(check_in: Time.zone.now)

    render 'ubs/check_in/patient_details'
  end

  def confirm_check_out
    @patient = Patient.find(params[:patient_id])
    @appointments = Appointment.where(patient_id: @patient.id)

    @appointments&.last.update(check_out: Time.zone.now)

    render 'ubs/check_in/patient_details'
  end

  def check_out_patients
    today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    @check_out_appointments = Appointment.where.not(check_in: nil).where(start: today_range, check_out: nil)

    @appointments_patients = []

    @check_out_appointments.each do |appointment|
      patient = Patient.find(appointment.patient_id)

      @appointments_patients << { start: appointment.start, name: patient.name, cpf: patient.cpf }
    end

    render 'ubs/check_in/check_out_patients'
  end
end
