class AddChronicToPatient < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :chronic, :boolean
  end
end
