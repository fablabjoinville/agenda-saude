class AddAppointmentFlowFields < ActiveRecord::Migration[6.0]
  def change
    add_column :appointments, :check_in, :datetime
    add_column :appointments, :check_out, :datetime
    add_column :appointments, :second_dose, :boolean, default: false
  end
end
