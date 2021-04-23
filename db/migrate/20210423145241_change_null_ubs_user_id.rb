class ChangeNullUbsUserId < ActiveRecord::Migration[6.1]
  def change
    change_column :ubs, :user_id, :bigint, null: true, default: nil
  end
end
