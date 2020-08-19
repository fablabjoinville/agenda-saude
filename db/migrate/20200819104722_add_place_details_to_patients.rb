class AddPlaceDetailsToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :public_place, :string
    add_column :patients, :place_number, :string
  end
end
