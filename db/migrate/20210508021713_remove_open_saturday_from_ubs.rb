class RemoveOpenSaturdayFromUbs < ActiveRecord::Migration[6.1]
  def change
    remove_column :ubs, :open_saturday, :boolean, default: false
  end
end
