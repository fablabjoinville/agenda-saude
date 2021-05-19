class UniqueGroupPatients < ActiveRecord::Migration[6.1]
  def change
    remove_index :groups_patients, %i[patient_id group_id]
    add_index :groups_patients, %i[patient_id group_id], unique: true
  end
end
