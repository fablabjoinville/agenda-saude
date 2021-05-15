class CreateTimeSlotGeneratorExecution < ActiveRecord::Migration[6.0]
  # rubocop:disable Rails/CreateTableWithTimestamps
  def change
    create_table :time_slot_generator_executions, id: false do |t|
      t.date :date, primary_key: true
      t.text :status
      t.text :details
    end
  end
  # rubocop:enable Rails/CreateTableWithTimestamps
end
