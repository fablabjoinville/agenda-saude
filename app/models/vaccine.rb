class Vaccine < ApplicationRecord
  has_many :doses, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :formal_name, presence: true
end
