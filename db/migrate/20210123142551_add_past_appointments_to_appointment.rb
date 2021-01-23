class AddPastAppointmentsToAppointment < ActiveRecord::Migration[6.0]
  def change
    add_column :appointments, :past_appointments, :integer, array: true, default: []
  end
end
