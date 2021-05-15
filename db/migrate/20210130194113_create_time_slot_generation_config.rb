class CreateTimeSlotGenerationConfig < ActiveRecord::Migration[6.0]
  # rubocop:disable Rails/CreateTableWithTimestamps
  def change
    create_table :time_slot_generation_configs, id: false do |t|
      t.integer :ubs_id, primary_key: true
      t.text :content
    end
  end
  # rubocop:enable Rails/CreateTableWithTimestamps
end
