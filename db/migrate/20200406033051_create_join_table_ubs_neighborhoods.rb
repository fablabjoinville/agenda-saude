class CreateJoinTableUbsNeighborhoods < ActiveRecord::Migration[6.0]
  def change
    create_join_table :ubs, :neighborhoods do |t|
      t.index %i[ubs_id neighborhood_id]
      t.index %i[neighborhood_id ubs_id]
    end
  end
end
