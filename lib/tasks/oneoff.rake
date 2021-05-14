namespace :oneoff do
  desc 'Backfill neighborhoods on patients and ubs (idempotent)'
  task neighborhoods: [:environment] do
    puts 'Populating patients:'
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

    puts 'Populating ubs:'
    puts ActiveRecord::Base.connection.execute(%{
      WITH subquery AS (
        SELECT ubs.id AS "ubs_id", neighborhoods.id AS "neighborhood_id"
          FROM ubs
          INNER JOIN neighborhoods ON
            LOWER(neighborhoods.name) = LOWER(ubs.neighborhood)
      ) UPDATE ubs
        SET neighborhood_id = subquery.neighborhood_id
        FROM subquery
        WHERE
          ubs.id = subquery.ubs_id
    })&.inspect
  end
end
