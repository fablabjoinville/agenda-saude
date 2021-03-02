class RemoveActiveFromAppointments < ActiveRecord::Migration[6.0]
  def change
    remove_column :appointments, :active, :boolean
  end
end
