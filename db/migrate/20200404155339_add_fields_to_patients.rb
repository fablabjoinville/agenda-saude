class AddFieldsToPatients < ActiveRecord::Migration[6.0]
  # rubocop:disable Rails/BulkChangeTable
  def change
    change_table :patients do |t|
      t.string :name, null: false, default: ''
      t.string :cpf, null: false, default: ''
      t.string :mother_name, null: false, default: ''
      t.string :birth_date
      t.string :phone
      t.string :other_phone
      t.string :sus
      t.string :neighborhood
    end

    add_index :patients, :cpf, unique: true
  end
  # rubocop:enable Rails/BulkChangeTable
end
