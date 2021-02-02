class AddSuspendReasonToAppointments < ActiveRecord::Migration[6.0]
  def change
    add_column :appointments, :suspend_reason, :string
  end
end
