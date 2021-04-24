class ChangeNullUbsUserId < ActiveRecord::Migration[6.1]
  def up
    change_column :ubs, :user_id, :bigint, null: true, default: nil
  end

  def down
    change_column :ubs, :user_id, :bigint, null: false
  end
end
