class AddPlaceDetailsToPatients < ActiveRecord::Migration[6.0]
  # rubocop:disable Rails/BulkChangeTable
  def change
    add_column :patients, :public_place, :string
    add_column :patients, :place_number, :string
  end
  # rubocop:enable Rails/BulkChangeTable
end
