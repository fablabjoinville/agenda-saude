class AddCommorbidityToAppointments < ActiveRecord::Migration[6.0]
  def change
    add_column :appointments, :commorbidity, :boolean, default: false
  end
end
