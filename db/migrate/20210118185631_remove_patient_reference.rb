class RemovePatientReference < ActiveRecord::Migration[6.0]
  def change
    remove_reference :appointments, :patient, index: true, foreign_key: true
    add_column :appointments, :patient_id, :integer
  end
end
