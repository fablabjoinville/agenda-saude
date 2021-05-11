class AddNeighborhoodIdToUbs < ActiveRecord::Migration[6.1]
  def change
    add_column :ubs, :neighborhood_id, :bigint, null: true, foreign_key: true
  end
end
