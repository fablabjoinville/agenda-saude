class AddCnesToUbs < ActiveRecord::Migration[6.0]
  def change
    add_column :ubs, :cnes, :string, uniqueness: true
  end
end
