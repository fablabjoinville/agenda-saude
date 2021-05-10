class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages do |t|
      t.string :path, index: true, unique: true, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.integer :context, null: false, index: true

      t.timestamps
    end
  end
end
