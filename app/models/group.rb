class Group < ApplicationRecord
  has_and_belongs_to_many :patients

  enum context: { priority: 0, comorbidity: 1 }

  belongs_to :parent_group, optional: true, class_name: 'Group'
  has_many :children, class_name: 'Group', foreign_key: :parent_group_id, dependent: :destroy, inverse_of: :parent_group

  scope :root, -> { where(parent_group_id: nil) }
  scope :active, -> { where(active: true) }
  scope :admin_order, -> { order(active: :desc, context: :asc, parent_group_id: :desc, position: :asc) }

  def name_with_parent
    return name unless parent_group

    "#{parent_group.name}: #{name}"
  end
end
