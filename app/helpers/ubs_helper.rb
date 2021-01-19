module UbsHelper
  def find_appointment_patient(id)
    Patient.find(id)
  end
end
