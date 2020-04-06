class AddNeighborhoodToUbs < ActiveRecord::Migration[6.0]
  def change
    rename_column :ubs, :neighborhood, :neighborhood_name
  end
end
