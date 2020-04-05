class AddAddressToUbs < ActiveRecord::Migration[6.0]
  def change
    add_column :ubs, :address, :string, default: ''
  end
end
