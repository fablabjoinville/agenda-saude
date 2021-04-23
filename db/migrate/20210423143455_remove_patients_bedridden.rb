class RemovePatientsBedridden < ActiveRecord::Migration[6.1]
  def change
    remove_column :patients, :bedridden, :boolean, default: false
  end
end
