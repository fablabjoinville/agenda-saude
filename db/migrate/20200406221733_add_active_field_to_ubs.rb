class AddActiveFieldToUbs < ActiveRecord::Migration[6.0]
  def change
    add_column :ubs, :active, :boolean, default: false
  end
end
