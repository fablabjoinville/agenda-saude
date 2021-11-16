class AddEnabledForRescheduleToUbs < ActiveRecord::Migration[6.1]
  def change
    add_column :ubs, :enabled_for_reschedule, :boolean, null: false, default: false
  end
end
