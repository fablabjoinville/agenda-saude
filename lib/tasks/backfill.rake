namespace :backfill do
  desc 'Backfill vaccines (idempotent, can be run as many time as needed)'
  task vaccines: [:environment, 'seeding:vaccines'] do
    Appointment.distinct(:vaccine_name).pluck(:vaccine_name).compact.each do |vaccine_name|
      vaccine = Vaccine.find_by!(legacy_name: vaccine_name)
      puts "For vaccine #{vaccine.name}:"
      Appointment
        .includes(:dose).where(dose: { id: nil })
        .where.not(check_in: nil)
        .where.not(check_out: nil)
        .where(vaccine_name: vaccine_name)
        .order(:check_out)
        .each do |appointment|
        sequence_number = appointment.patient.doses.where(vaccine: vaccine).count
        dose = appointment.patient.doses.create! appointment: appointment,
                                                 vaccine: vaccine,
                                                 sequence_number: sequence_number + 1,
                                                 created_at: appointment.check_out,
                                                 updated_at: appointment.check_out
        print dose.sequence_number.to_s
      end
      puts
    end
  end

  desc 'Backfill users-ubs relationship (idempotent)'
  task users_ubs: [:environment] do
    Ubs.all.each do |ubs|
      ubs.users = [ubs.user]
    end
  end

  desc 'Backfill follow ups'
  task follow_up_appointments: [:environment] do
    puts ActiveRecord::Base.connection.execute(%{
      WITH subquery AS (
        SELECT d.id AS "id", a.id AS "follow_up_appointment_id"
          FROM doses AS d
          INNER JOIN vaccines AS v ON
            v.id = d.vaccine_id
          INNER JOIN appointments AS a ON
            a.patient_id = d.patient_id
            AND a.id != d.appointment_id
            AND a.vaccine_name = v.legacy_name
          WHERE
            d.sequence_number = 1
            AND d.follow_up_appointment_id IS NULL
      ) UPDATE doses
        SET follow_up_appointment_id = subquery.follow_up_appointment_id
        FROM subquery
        WHERE
          doses.id = subquery.id
    })&.inspect
  end
end
