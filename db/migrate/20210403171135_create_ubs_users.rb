class CreateUbsUsers < ActiveRecord::Migration[6.1]
  # rubocop:disable Rails/CreateTableWithTimestamps
  def change
    create_table :ubs_users do |t|
      t.references :ubs, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.index %i[ubs_id user_id], unique: true
    end
  end
  # rubocop:enable Rails/CreateTableWithTimestamps
end
