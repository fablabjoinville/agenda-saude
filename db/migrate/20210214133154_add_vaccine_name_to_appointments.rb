class AddVaccineNameToAppointments < ActiveRecord::Migration[6.0]
  def change
    add_column :appointments, :vaccine_name, :string
  end
end
