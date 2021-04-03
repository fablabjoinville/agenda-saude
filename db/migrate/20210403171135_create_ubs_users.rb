class CreateUbsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :ubs_users do |t|
      t.references :ubs, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.index [:ubs_id, :user_id], unique: true
    end
  end
end
