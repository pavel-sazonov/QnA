require 'rails_helper'
require 'capybara/poltergeist'

RSpec.configure do |config|
  Capybara.server = :puma
  Capybara.javascript_driver = :poltergeist
  Capybara.default_max_wait_time = 5

  config.include AcceptanceHelpers, type: :feature
  config.include OmniauthMacros
  config.include SphinxHelpers, type: :feature


  config.use_transactional_fixtures = false

  config.before(:suite) do
    if config.use_transactional_fixtures?
      raise(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.
        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:suite) do
    # Ensure sphinx directories exist for the test environment
      ThinkingSphinx::Test.init
      # Configure and start Sphinx, and automatically
      # stop Sphinx at the end of the test suite.
      ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  OmniAuth.config.test_mode = true
end

  # config.include AcceptanceHelpers, type: :feature
  # config.include OmniauthMacros
  # config.include SphinxHelpers, type: :feature

  # config.before(:suite) do
  #   # Ensure sphinx directories exist for the test environment
  #   ThinkingSphinx::Test.init
  #   # Configure and start Sphinx, and automatically
  #   # stop Sphinx at the end of the test suite.
  #   ThinkingSphinx::Test.start_with_autostop
  # end

  # # config.before(:each) do
  # #   # Index data when running an acceptance spec.
  # #   index if example.metadata[:js]
  # # end

  # config.after(:all) do
  #   if Rails.env.test?
  #     FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/test/attachment/"])
  #   end
  # end

  # config.use_transactional_fixtures = false

  # # config.before(:suite) do
  # #   DatabaseCleaner.clean_with :truncation
  # # end

  # config.before(:each) do
  #   DatabaseCleaner.strategy = :transaction
  # end

  # config.before(:each, :sphinx => true) do
  #   # For tests tagged with Sphinx, use deletion (or truncation)
  #   DatabaseCleaner.strategy = :deletion
  # end

  # # config.before(:each, js: true) do
  # #   DatabaseCleaner.strategy = :truncation
  # # end

  # config.before(:each) do
  #   DatabaseCleaner.start
  # end

  # # config.after(:each) do
  # #   DatabaseCleaner.clean
  # # end

  # config.append_after(:each) do
  #   DatabaseCleaner.clean
  # end

  # OmniAuth.config.test_mode = true
# end
