class AddIndexToNeighborhoods < ActiveRecord::Migration[6.0]
  def change
    add_column :neighborhoods, :index, :int, null: false
  end
end
