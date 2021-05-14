# frozen_string_literal: true

Rails.logger = Logger.new($stdout)
Rails.logger.datetime_format = '%H:%M:%S'

Dir[Rails.root.join('db/seeds/*service.rb')].each do |seed|
  load seed
end

Dir[Rails.root.join('db/seeds/application/*.rb')].each do |seed|
  Rails.logger.info "[application] #{File.basename(seed)}"
  load seed
end

unless Rails.env.production?
  Dir[Rails.root.join('db/seeds/development/*.rb')].each do |seed|
    Rails.logger.info "[dev] #{File.basename(seed)}"
    load seed
  end
end
