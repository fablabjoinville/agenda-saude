class ChangeUserFields < ActiveRecord::Migration[6.0]
  # rubocop:disable Rails/BulkChangeTable
  def change
    add_column :users, :name, :string, null: false, default: ''
    change_column :users, :email, :string, null: true, uniqueness: false
  end
  # rubocop:enable Rails/BulkChangeTable
end
