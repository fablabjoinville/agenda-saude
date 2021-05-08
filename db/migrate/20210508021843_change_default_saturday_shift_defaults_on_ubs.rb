class ChangeDefaultSaturdayShiftDefaultsOnUbs < ActiveRecord::Migration[6.1]
  def change
    change_table :ubs, bulk: true do |t|
      t.string :saturday_shift_start, null: true, default: nil
      t.string :saturday_break_start, null: true, default: nil
      t.string :saturday_break_end, null: true, default: nil
      t.string :saturday_shift_end, null: true, default: nil
    end
  end
end
