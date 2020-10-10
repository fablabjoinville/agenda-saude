# frozen_string_literal: true

require_relative 'boot'

require 'rails'

# action_mailbox/engine
# action_text/engine
%w(
  action_cable/engine
  active_record/railtie
  active_storage/engine
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  rails/test_unit/railtie
  sprockets/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TemplateRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

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
    config.i18n.available_locales = ['pt-BR', 'en']
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
