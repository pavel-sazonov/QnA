require 'rails_helper'
require 'capybara/poltergeist'

RSpec.configure do |config|
  Capybara.javascript_driver = :poltergeist
  Capybara.default_max_wait_time = 5

  config.include AcceptanceHelpers, type: :feature
end
