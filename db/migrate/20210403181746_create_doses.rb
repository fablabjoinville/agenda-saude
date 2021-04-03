class CreateDoses < ActiveRecord::Migration[6.1]
  def change
    create_table :doses do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :schedule, null: false, foreign_key: true
      t.references :vaccine, null: false, foreign_key: true
      t.integer :sequence_number, default: 1, null: false

      t.timestamps
    end
  end
end
