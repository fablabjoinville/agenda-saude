class AddLastAppointmentToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :last_appointment, :datetime
  end
end
