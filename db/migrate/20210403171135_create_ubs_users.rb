class CreateUbsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :ubs_users do |t|
      t.references :ubs
      t.references :user

      t.index ["ubs_id", "user_id"]
      t.index ["user_id", "ubs_id"]
    end
  end
end
