class AddOpenSaturdayToUbs < ActiveRecord::Migration[6.0]
  def change
    add_column :ubs, :open_saturday, :boolean, default: false
    add_column :ubs, :saturday_shift_start, :string, default: '9:00'
    add_column :ubs, :saturday_break_start, :string, default: '12:30'
    add_column :ubs, :saturday_break_end, :string, default: '13:30'
    add_column :ubs, :saturday_shift_end, :string, default: '17:00'
  end
end
