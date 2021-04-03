class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :appointment, null: false, foreign_key: true
      t.timestamp :checked_in_at, null: true, default: nil
      t.timestamp :checked_out_at, null: true, default: nil
      t.timestamp :canceled_at, null: true, default: nil
      t.string :canceled_reason, null: true, default: nil

      t.timestamps
    end
  end
end
