class CreateVaccines < ActiveRecord::Migration[6.1]
  def change
    create_table :vaccines do |t|
      t.string :name, unique: true, index: true
      t.string :formal_name
      t.integer :second_dose_after_in_days, default: nil, null: true
      t.integer :third_dose_after_in_days, default: nil, null: true
      t.string :legacy_name, default: nil, null: true, index: true, unique: true

      t.timestamps
    end
  end
end
