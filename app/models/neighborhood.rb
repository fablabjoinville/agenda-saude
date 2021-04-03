class Neighborhood < ApplicationRecord
  has_and_belongs_to_many :ubs
  has_many :patients, dependent: :nullify

  def active_ubs
    ubs.select(&:active)
  end
end
