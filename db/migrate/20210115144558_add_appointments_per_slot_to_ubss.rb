class AddAppointmentsPerSlotToUbss < ActiveRecord::Migration[6.0]
  def change
    add_column :ubs, :appointments_per_time_slot, :integer, default: 1
  end
end
