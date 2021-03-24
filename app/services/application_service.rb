# Base Application Service so we can have a common shared interface between all services
class ApplicationService
  class ServiceError < StandardError; end

  def self.call(*args, &block)
    new(*args, &block).()
  end
end
