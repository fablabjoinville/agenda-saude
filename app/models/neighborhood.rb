class Neighborhood < ApplicationRecord
  has_and_belongs_to_many :ubs

  def active_ubs
    ubs.select(&:active)
  end
end
