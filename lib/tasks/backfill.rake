namespace :backfill do
  desc 'Backfill vaccines (idempotent)'
  task vaccines: [:environment] do
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

  desc 'Backfill follow ups (idempotent)'
  task follow_up_appointments: [:environment] do
    puts 'Cleaning column:'
    puts ActiveRecord::Base.connection.execute(%(
      UPDATE doses
      SET follow_up_appointment_id = NULL
      WHERE
        follow_up_appointment_id != NULL
    ))&.inspect

    puts 'Populating column:'
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
      ) UPDATE doses
        SET follow_up_appointment_id = subquery.follow_up_appointment_id
        FROM subquery
        WHERE
          doses.id = subquery.id
    })&.inspect
  end

  desc 'Backfill root groups (idempotent)'
  task root_groups: [:environment] do
    Group.root.select { |g| g.children.any? }.map do |root|
      puts ActiveRecord::Base.connection.execute(%{
        insert into groups_patients (patient_id, group_id) (
          select patient_id, #{root.id}
            from groups_patients
            where group_id in (#{root.children.pluck(:id).join(', ')})
            group by patient_id
        ) on conflict do nothing
      })&.inspect
    end
  end
end
