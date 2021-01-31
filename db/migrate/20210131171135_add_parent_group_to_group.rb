class AddParentGroupToGroup < ActiveRecord::Migration[6.0]
  def change
    add_reference :groups, :parent_group, null: true, references: :groups
  end
end
