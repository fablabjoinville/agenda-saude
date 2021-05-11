class RemoveTimeSlotGeneratorExecution < ActiveRecord::Migration[6.1]
  def change
    drop_table :time_slot_generator_executions, primary_key: :date, id: :date, force: :cascade do |t|
      t.text :status
      t.text :details
    end
  end
end
