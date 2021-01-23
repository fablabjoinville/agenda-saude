class CheckInController < UserSessionController
  before_action :ubs

  def search
    render 'ubs/check_in/index'
  end

  def find_patients
    @ubs = Ubs.find(params[:ubs_id])

    if params[:patient][:cpf].present?
      @patients = Patient.where(cpf: params[:patient][:cpf])

      @appointments_patients = build_appointments_patients(@patients)
    elsif params[:patient][:name].present?
      @patients = Patient.where('name ~* ?', params[:patient][:name])

      @appointments_patients = build_appointments_patients(@patients)
    end

    render 'ubs/check_in/found_patients'
  end

  def patient_details
    patient = Patient.find(params[:patient_id])

    @patient = {
      id: patient.id,
      age: calculate_age(patient.birth_date),
      name: patient.name,
      cpf: patient.cpf,
      health_professional: patient.groups.include?(Group.first),
      chronic_disability: patient.groups.include?(Group.fourth)
    }

    @appointments = Appointment.where(patient_id: patient.id)

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

    render 'ubs/check_in/check_out_patients'
  end

  def cancel_appointment
    @patient = Patient.find(params[:patient_id])
    @appointment = Appointment.where(patient_id: @patient.id).last
    # TODO: Verify what happens with a patient which has his appointment canceled

    render 'ubs/check_in/cancelled_appointment'
  end

  def check_out_patients
    today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    @check_out_appointments = Appointment.where.not(check_in: nil).where(start: today_range, check_out: nil)

    @appointments_patients = []

    @check_out_appointments.each do |appointment|
      patient = Patient.find(appointment.patient_id)

      @appointments_patients << {
        id: patient.id,
        name: patient.name,
        cpf: patient.cpf,
        appointment_day: appointment.start.strftime('%d/%m'),
        appointment_hour: appointment.start.strftime('%H:%M'),
        appointment_start: appointment.start
      }
    end

    @appointments_patients = @appointments_patients.sort_by { |appointment| appointment[:appointment_start] }

    render 'ubs/check_in/check_out_patients'
  end

  private

  def ubs
    @ubs ||= Ubs.find(params[:ubs_id])
  end

  def build_appointments_patients(patients)
    appointments_patients = []

    patients.each do |patient|
      appointment = Appointment.find_by(patient_id: patient.id, start: 1.hour.ago..Time.zone.now.end_of_day)

      next if appointment.nil?

      appointments_patients << {
        id: patient.id,
        name: patient.name,
        cpf: patient.cpf,
        appointment_day: appointment.start.strftime('%d/%m'),
        appointment_hour: appointment.start.strftime('%H:%M'),
        appointment_start: appointment.start
      }
    end

    appointments_patients = appointments_patients.sort_by { |appointment| appointment[:appointment_start] }

    appointments_patients
  end

  def calculate_age(age)
    birth_date = age.to_time

    ((Time.zone.now - birth_date.to_time) / 1.year.seconds).floor
  end
end
