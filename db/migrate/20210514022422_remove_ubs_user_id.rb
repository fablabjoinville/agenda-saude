class RemoveUbsUserId < ActiveRecord::Migration[6.1]
  def change
    remove_column :ubs, :user_id, :bigint, index: true
  end
end
