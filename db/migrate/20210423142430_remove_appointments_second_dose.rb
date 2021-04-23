class RemoveAppointmentsSecondDose < ActiveRecord::Migration[6.1]
  def change
    remove_column :appointments, :second_dose, :boolean, default: false
  end
end
