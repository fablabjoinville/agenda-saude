class AddFollowUpAppointmentIdIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :doses, :follow_up_appointment_id
  end
end
