class AddTargetAudienceToPatient < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :target_audience, :integer
  end
end
