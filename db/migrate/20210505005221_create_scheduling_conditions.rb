class CreateSchedulingConditions < ActiveRecord::Migration[6.1]
  def change
    create_table :scheduling_conditions do |t|
      t.string :name
      t.datetime :start_at, index: true, null: false
      t.boolean :active, null: false, default: false, index: true

      t.integer :min_age, null: true, default: nil
      t.integer :max_age, null: true, default: nil

      t.timestamps
    end
  end
end
