class CreateNeighborhoods < ActiveRecord::Migration[6.0]
  # rubocop:disable Rails/CreateTableWithTimestamps
  def change
    create_table :neighborhoods do |t|
      t.string :name
    end
  end
  # rubocop:enable Rails/CreateTableWithTimestamps
end
