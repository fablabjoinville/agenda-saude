class AddPhoneToUbs < ActiveRecord::Migration[6.0]
  def change
    add_column :ubs, :phone, :string
  end
end
