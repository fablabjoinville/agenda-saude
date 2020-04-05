class AddFakeMothersToPatient < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :fake_mothers, :string, array: true, default: []
  end
end
