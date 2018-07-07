require 'rails_helper'
require 'capybara/poltergeist'

RSpec.configure do |config|
  Capybara.server = :puma
  Capybara.javascript_driver = :poltergeist
  Capybara.default_max_wait_time = 5

  config.include AcceptanceHelpers, type: :feature

  config.after(:all) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/test/attachment/"])
    end
  end
end
