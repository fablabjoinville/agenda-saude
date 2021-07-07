class ChangeNullForBirthdayOnPatients < ActiveRecord::Migration[6.1]
  def change
    change_column :patients, :birthday, :date, null: false, uniqueness: false
  end
end
