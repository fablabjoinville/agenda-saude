class CreateConditionsUbs < ActiveRecord::Migration[6.1]
  def change
    create_table :conditions_ubs do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :ubs, null: false, foreign_key: true
      t.references :condition, null: false, foreign_key: true

      t.index %i[condition_id ubs_id], name: 'index_conditions_ubs_on_cgu_id'
      t.index %i[ubs_id condition_id], name: 'index_conditions_ubs_on_usc_id'
    end
  end
end
