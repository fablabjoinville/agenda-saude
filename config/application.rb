# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
# require "action_mailbox/engine"
# require "action_text/engine"
# require "active_storage/engine"
# require "rails/test_unit/railtie"
require 'action_cable/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'active_job/railtie'
require 'active_model/railtie'
require 'active_record/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AgendaSaude
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.x.schedule_from_hours = ENV.fetch('SCHEDULE_FROM_HOURS', 1).to_i # Patient can't schedule free appointments before 1 hour in the future
    config.x.schedule_up_to_days = ENV.fetch('SCHEDULE_UP_TO_DAYS', 10).to_i # Patient can't schedule free appointments after 10 days in the future
    config.x.late_patient_tolerance_minutes = ENV.fetch('LATE_PATIENT_TOLERANCE_MINUTES', 10).to_i.minutes
    config.x.early_patient_warning_minutes = ENV.fetch('EARLY_PATIENT_WARNING_MINUTES', 30).to_i.minutes
    config.x.patient_force_update_before = ENV.fetch('PATIENT_FORCE_UPDATE_BEFORE', '2020-01-01 00:00:00')
    config.x.rate_limit_per_minute = ENV.fetch('RATE_LIMIT_PER_MINUTE', '60').to_i
    config.x.site_title = ENV.fetch('SITE_TITLE', 'Agenda de Vacinação').to_s

    # https://guides.rubyonrails.org/autoloading_and_reloading_constants.html#autoload-paths
    config.autoload_paths += [
      Rails.root.join('app/services'),
      Rails.root.join('app/validators')
    ]

    config.generators do |generator|
      generator.test_framework :rspec, fixtures: false
      generator.fixture_replacement :factory_bot
      generator.factory_bot dir: 'spec/factories', suffix: 'factory'
    end

    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]
    config.i18n.available_locales = %w[pt-BR en]
    config.i18n.default_locale = :'pt-BR'
    config.time_zone = ENV.fetch('TIME_ZONE', 'Brasilia')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    #
    config.action_controller.include_all_helpers = true
  end
end
