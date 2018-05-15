require 'rails_helper'

RSpec.configure do |config|
  # Capybara.javascript_driver = :webkit

  config.include AcceptanceHelpers, type: :feature
end
