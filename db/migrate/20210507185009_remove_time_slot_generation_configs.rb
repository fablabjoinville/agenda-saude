class RemoveTimeSlotGenerationConfigs < ActiveRecord::Migration[6.1]
  def change
    drop_table :time_slot_generation_configs, primary_key: :ubs_id, id: :serial, force: :cascade do |t|
      t.text :content
    end
  end
end
