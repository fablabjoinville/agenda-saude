class AddPositionToGroups < ActiveRecord::Migration[6.1]
  def change
    change_table :groups, bulk: true do |t|
      t.integer :context, default: 0, null: false, index: true
      t.integer :position, default: 0, null: false, index: true
      t.boolean :active, default: true, null: false, index: true
    end
  end
end
