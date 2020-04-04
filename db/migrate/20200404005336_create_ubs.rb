class CreateUbs < ActiveRecord::Migration[6.0]
  def change
    create_table :ubs do |t|
      t.string :name
      t.string :neighborhood
      t.references :user, null: false, foreign_key: true
      t.string :shift_start
      t.string :shift_end
      t.string :break_start
      t.string :break_end

      t.timestamps
    end
  end
end
