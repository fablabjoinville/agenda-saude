class AddUbsRefToAppointments < ActiveRecord::Migration[6.0]
  def change
    add_reference :appointments, :ubs, foreign_key: true
  end
end
