class AddBedriddenToPatient < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :bedridden, :bool, default: false
  end
end
