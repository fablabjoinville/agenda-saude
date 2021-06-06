class RemoveVaccinesLegacyName < ActiveRecord::Migration[6.1]
  def change
    remove_column :vaccines, :legacy_name, :string
  end
end
