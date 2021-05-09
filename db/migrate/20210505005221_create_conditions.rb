class CreateConditions < ActiveRecord::Migration[6.1]
  def change
    create_table :conditions do |t|
      t.string :name
      t.datetime :start_at, index: true, null: false
      t.datetime :end_at, index: true, null: false

      t.integer :min_age, null: true, default: nil
      t.integer :max_age, null: true, default: nil

      t.boolean :can_register, null: false, default: false
      t.boolean :can_schedule, null: false, default: false

      t.timestamps
    end
  end
end
