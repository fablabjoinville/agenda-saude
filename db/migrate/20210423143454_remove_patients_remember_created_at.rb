class RemovePatientsRememberCreatedAt < ActiveRecord::Migration[6.1]
  def change
    remove_column :patients,:remember_created_at, :datetime
  end
end
