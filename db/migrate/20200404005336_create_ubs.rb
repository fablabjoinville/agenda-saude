class CreateUbs < ActiveRecord::Migration[6.0]
  def change
    create_table :ubs do |t|
      t.string :name
      t.string :neighborhood
      t.references :user, null: false, foreign_key: true
      t.time :shift_start
      t.time :shift_end
      t.time :break_start
      t.time :break_end

      t.timestamps
    end
  end
end
