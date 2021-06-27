require 'capybara'
require 'capybara/apparition'

Capybara.register_driver :apparition do |app|
  Capybara::Apparition::Driver.new(
    app,
    debug: false,
    headless: ENV['OPEN_BROWSER'].blank?,
    screen_size: [1200, 900],
    skip_image_loading: true
  )
end

Capybara.default_driver = :apparition
Capybara.javascript_driver = :apparition
Capybara.server = :puma, { Silent: true }
