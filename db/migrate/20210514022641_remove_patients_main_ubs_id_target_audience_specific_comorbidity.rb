class RemovePatientsMainUbsIdTargetAudienceSpecificComorbidity < ActiveRecord::Migration[6.1]
  # rubocop:disable Rails/BulkChangeTable
  def change
    remove_column :patients, :main_ubs_id, :bigint, index: true
    remove_column :patients, :target_audience, :integer
    remove_column :patients, :specific_comorbidity, :string, default: ''
  end
  # rubocop:enable Rails/BulkChangeTable
end
