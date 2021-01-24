class ChangeLastAppointmentToInteger < ActiveRecord::Migration[6.0]
  def change
    remove_column :patients, :last_appointment, :datetime
    add_reference :patients, :last_appointment, null: true, foreign_key: { to_table: :appointments }
  end
end
