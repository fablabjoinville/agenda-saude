class AddMainUbsToPatient < ActiveRecord::Migration[6.0]
  def change
    add_reference :patients, :main_ubs, null: true, foreign_key: { to_table: :ubs }
  end
end
