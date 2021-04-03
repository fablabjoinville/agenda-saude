class Vaccine < ApplicationRecord
  has_many :doses, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
  validates :formal_name, presence: true
  validates :legacy_name, uniqueness: { allow_nil: true }
end
