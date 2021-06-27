require 'webdrivers'

require 'capybara'
require 'capybara/apparition'

Capybara.javascript_driver = :apparition
Capybara.server = :puma, { Silent: true }
