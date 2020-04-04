class AddFieldsToPatients < ActiveRecord::Migration[6.0]
  def change
    change_table :patients do |t|
      t.string :name
      t.string :cpf
      t.string :mother_name
      t.string :birth_date
      t.string :phone
      t.string :other_phone
      t.string :sus
      t.string :neighborhood
    end
  end
end
