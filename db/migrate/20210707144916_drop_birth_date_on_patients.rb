class DropBirthDateOnPatients < ActiveRecord::Migration[6.1]
  def change
    remove_column :patients, :birth_date, :string
  end
end
