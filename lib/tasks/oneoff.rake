namespace :oneoff do
  desc 'Backfill neighborhoods on patients (idempotent)'
  task neighborhoods: [:environment] do
    puts 'Populating column:'
    puts ActiveRecord::Base.connection.execute(%{
      WITH subquery AS (
        SELECT patients.id AS "patient_id", neighborhoods.id AS "neighborhood_id"
          FROM patients
          INNER JOIN neighborhoods ON
            LOWER(neighborhoods.name) = LOWER(patients.neighborhood)
      ) UPDATE patients
        SET neighborhood_id = subquery.neighborhood_id
        FROM subquery
        WHERE
          patients.id = subquery.patient_id
    })&.inspect
  end
end
