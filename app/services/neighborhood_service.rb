module NeighborhoodService
  def self.list
    Neighborhood.pluck(:name)
  end
end
