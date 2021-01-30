class AddComorbidityToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :comorbidity, :boolean, default: false
  end
end
