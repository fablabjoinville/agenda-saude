namespace :backfill do
  desc "Backfill vaccines"
  task vaccines: :environment do
    Appointment.distinct(:vaccine_name).pluck(:vaccine_name).compact.each do |vaccine_name|
      vaccine = Vaccine.find_by!(legacy_name: vaccine_name)
      puts "For vaccine #{vaccine.name}:"
      Appointment.
        includes(:dose).where(dose: { id: nil}).
        where.not(check_in: nil, check_out: nil).
        where(vaccine_name: vaccine_name).
        order(:check_out).
        each do |appointment|
        sequence_number = appointment.patient.doses.where(vaccine: vaccine).count
        dose = appointment.patient.doses.create! appointment: appointment,
                                                 vaccine: vaccine,
                                                 sequence_number: sequence_number + 1,
                                                 created_at: appointment.check_out,
                                                 updated_at: appointment.check_out
        print "#{dose.sequence_number}"
      end
      puts
    end
  end
end
