class AddLoginAttemptsToPatient < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :login_attempts, :int, default: 0
  end
end
