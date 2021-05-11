class AddSundayShiftsToUbs < ActiveRecord::Migration[6.1]
  def change
    change_table :ubs, bulk: true do |t|
      t.string :sunday_shift_start
      t.string :sunday_break_start
      t.string :sunday_break_end
      t.string :sunday_shift_end
    end
  end
end
