class CreateConditionsGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :conditions_groups do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :group, null: false, foreign_key: true
      t.references :condition, null: false, foreign_key: true

      t.index %i[group_id condition_id], name: 'index_conditions_groups_on_gsc_id'
      t.index %i[condition_id group_id], name: 'index_conditions_groups_on_scg_id'
    end
  end
end
