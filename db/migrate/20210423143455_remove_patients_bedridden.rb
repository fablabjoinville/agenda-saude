class RemovePatientsDeprecatedColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :patients,:remember_created_at, :datetime
    remove_column :patients, :bedridden, :boolean, default: false
    remove_column :patients, :chronic, :boolean
  end
end
