class RemoveUbsNeighborhood < ActiveRecord::Migration[6.1]
  def change
    remove_column :ubs, :neighborhood, :string
  end
end
