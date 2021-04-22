class AddAdminFlagToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :administrator, :boolean, null: false, default: false
  end
end
