class AddCheckInAndCheckOutToAppointments < ActiveRecord::Migration[6.0]
  def change
    add_column :appointments, :check_in, :datetime
    add_column :appointments, :check_out, :datetime
  end
end
