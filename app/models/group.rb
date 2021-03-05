class Group < ApplicationRecord
  has_and_belongs_to_many :patients
  belongs_to :parent_group, optional: true

  has_many :appointments, dependent: :restrict_with_exception
end
