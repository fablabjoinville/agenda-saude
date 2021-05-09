class ChangeDefaultSaturdayShiftDefaultsOnUbs < ActiveRecord::Migration[6.1]
  def change
    change_column_null :ubs, :saturday_shift_start, true
    change_column_default :ubs, :saturday_shift_start, from: "9:00", to: nil

    change_column_null :ubs, :saturday_break_start, true
    change_column_default :ubs, :saturday_break_start, from: "12:30", to: nil

    change_column_null :ubs, :saturday_break_end, true
    change_column_default :ubs, :saturday_break_end, from: "13:30", to: nil

    change_column_null :ubs, :saturday_shift_end, true
    change_column_default :ubs, :saturday_shift_end, from: "17:00", to: nil
  end
end
