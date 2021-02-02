class Group < ApplicationRecord
  has_and_belongs_to_many :patients
  belongs_to :parent_group, optional: true
end
