class CreateAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :appointments do |t|
      t.datetime :start
      t.datetime :end
      t.references :patient, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end

