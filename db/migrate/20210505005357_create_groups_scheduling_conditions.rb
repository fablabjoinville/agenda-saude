class CreateGroupsSchedulingConditions < ActiveRecord::Migration[6.1]
  def change
    create_table :groups_scheduling_conditions do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :group, null: false, foreign_key: true
      t.references :scheduling_condition, null: false, foreign_key: true

      t.index %i[group_id scheduling_condition_id], name: 'index_groups_scheduling_conditions_on_gsc_id'
      t.index %i[scheduling_condition_id group_id], name: 'index_groups_scheduling_conditions_on_scg_id'
    end
  end
end
