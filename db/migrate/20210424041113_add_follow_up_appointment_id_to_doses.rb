class AddFollowUpAppointmentIdToDoses < ActiveRecord::Migration[6.1]
  def change
    add_column :doses, :follow_up_appointment_id, :bigint, null: true, foreign_key: true
    add_foreign_key :doses, :appointments, column: :follow_up_appointment_id
  end
end
