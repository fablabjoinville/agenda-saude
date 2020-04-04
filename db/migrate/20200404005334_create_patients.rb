class CreatePatients < ActiveRecord::Migration[6.0]
  def change
    create_table :patients do |t|
      t.string :name
      t.string :cpf
      t.string :mother_name
      t.string :birth_date
      t.string :phone
      t.string :other_phone
      t.string :email
      t.string :sus
      t.string :neighborhood

      t.timestamps
    end
  end
end
