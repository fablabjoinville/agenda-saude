class AddNeighborhoodAndStreetToPatients < ActiveRecord::Migration[6.1]
  # rubocop:disable Rails/BulkChangeTable
  def change
    add_column :patients, :neighborhood_id, :bigint, null: true, foreign_key: true
    add_column :patients, :street_2, :string, null: true, default: nil
    add_column :patients, :internal_note, :string
  end
  # rubocop:enable Rails/BulkChangeTable
end
