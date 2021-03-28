# frozen_string_literal: true

require_relative 'boot'

require 'rails'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TemplateRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.x.admin_username = ENV.fetch("ADMIN_USERNAME", SecureRandom.uuid) # in case it isn't set, for safety
    config.x.admin_password = ENV.fetch("ADMIN_PASSWORD", SecureRandom.uuid)
    config.x.schedule_from_hours = 1 # Patient can't schedule free appointments before 1 hour in the future
    config.x.schedule_up_to_days = 7 # Patient can't schedule free appointments after 7 days in the future

    # https://guides.rubyonrails.org/autoloading_and_reloading_constants.html#autoload-paths
    config.autoload_paths += [
      Rails.root.join('app', 'services'),
      Rails.root.join('app', 'validators')
    ]

    config.generators do |generator|
      generator.test_framework :rspec, fixtures: false
      generator.fixture_replacement :factory_bot
      generator.factory_bot dir: 'spec/factories', suffix: 'factory'
    end

    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]
    config.i18n.available_locales = %w[pt-BR en]
    config.i18n.default_locale = :'pt-BR'
    config.time_zone = 'Brasilia'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    #
    config.action_controller.include_all_helpers = true
  end
end
