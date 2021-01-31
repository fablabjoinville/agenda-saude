class AddSpecificComorbidityToPatient < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :specific_comorbidity, :string, default: ''
  end
end
