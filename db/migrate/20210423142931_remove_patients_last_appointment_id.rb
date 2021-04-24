class RemovePatientsLastAppointmentId < ActiveRecord::Migration[6.1]
  def change
    remove_column :patients, :last_appointment_id, :bigint, index: true
  end
end
