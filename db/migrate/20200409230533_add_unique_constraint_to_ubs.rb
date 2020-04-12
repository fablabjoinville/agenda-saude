class AddUniqueConstraintToUbs < ActiveRecord::Migration[6.0]
  def change
    add_index :ubs, :cnes, unique: true
  end
end
