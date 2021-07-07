namespace :backfill do
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

  desc 'New birthday column'
  task birthday: [:environment] do
    puts 'Populating ubs:'
    puts ActiveRecord::Base.connection.execute(%{
      UPDATE patients
      SET birthday = TO_DATE(patients.birth_date,'YYYY-MM-DD')
      WHERE
        patients.birthday IS NULL
    })&.inspect
  end
end
