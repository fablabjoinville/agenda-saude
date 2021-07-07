class AddBirthdayToPatients < ActiveRecord::Migration[6.1]
  def change
    add_column :patients, :birthday, :date, null: true
    add_index :patients, :birthday
  end
end
