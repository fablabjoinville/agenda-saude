class RemoveAppointmentsVaccineName < ActiveRecord::Migration[6.1]
  def change
    remove_column :appointments, :vaccine_name, :string
  end
end
