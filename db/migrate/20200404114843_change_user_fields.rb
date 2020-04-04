class ChangeUserFields < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string, null: false, default: ''
    change_column :users, :email, :string, null: true, uniqueness: false
  end
end
