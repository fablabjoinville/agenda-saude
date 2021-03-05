class AddGroupRerefencesToAppointments < ActiveRecord::Migration[6.0]
  def change
    add_reference :appointments, :group, foreign_key: true
  end
end
