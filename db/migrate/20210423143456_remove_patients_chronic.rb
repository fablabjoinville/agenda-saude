class RemovePatientsChronic < ActiveRecord::Migration[6.1]
  def change
    remove_column :patients, :chronic, :boolean
  end
end
