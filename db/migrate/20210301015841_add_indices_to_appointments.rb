class AddIndicesToAppointments < ActiveRecord::Migration[6.0]
  def change
    add_index :appointments, :start
    add_index :appointments, :patient_id
  end
end
