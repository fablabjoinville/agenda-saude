class ChangeAppointmentActiveDefaultToTrue < ActiveRecord::Migration[6.0]
  def change
    change_column :appointments, :active, :boolean, default: true, null: false
  end
end
