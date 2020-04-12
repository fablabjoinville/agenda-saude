class AddUniqueConstraintToNeighborhood < ActiveRecord::Migration[6.0]
  def change
    add_index :neighborhoods, :name, unique: true
  end
end
