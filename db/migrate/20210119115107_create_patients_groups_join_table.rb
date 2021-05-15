class CreatePatientsGroupsJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :patients, :groups do |t|
      t.index %i[patient_id group_id]
      t.index %i[group_id patient_id]
    end
  end
end
