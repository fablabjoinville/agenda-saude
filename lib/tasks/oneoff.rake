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

  task disable_no_answers: [:environment] do
    Group.where(id: [998, 999]).each do |g|
      g.update! active: false
    end
  end

  task inquiry_page: [:environment] do
    [
      {
        path: 'patient_inquiry_intro',
        title: 'Introdução para o inquérito no cadastro de pacientes',
        body: 'Gostaria de participar de uma pesquisa epidemiológica? ' \
'Sua contribuição pode ajudar muito ao município melhor planejar as ações de combate ao Covid 19.',
        context: 'embedded'
      }
    ].each do |h|
      Page.find_or_initialize_by(path: h[:path]).tap do |page|
        page.attributes = h
        page.save!
      end
    end
  end

  task inquiry: [:environment] do
    load Rails.root.join('db/seeds/development/5_inquiry.rb')
  end

  task user_updated_at: [:environment] do
    puts ActiveRecord::Base.connection.execute(%(
      UPDATE patients
      SET user_updated_at = updated_at
      WHERE
        user_updated_at = NULL
    ))&.inspect
  end
end
