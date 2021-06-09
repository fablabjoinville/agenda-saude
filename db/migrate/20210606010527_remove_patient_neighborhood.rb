class RemovePatientNeighborhood < ActiveRecord::Migration[6.1]
  def change
    remove_column :patients, :neighborhood, :string
  end
end
