class AddUserUpdatedAtToPatients < ActiveRecord::Migration[6.1]
  def change
    add_column :patients, :user_updated_at, :datetime, null: true, default: nil
  end
end
