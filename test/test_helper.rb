ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

ActiveRecord::Migration.maintain_test_schema!

Minitest::Reporters.use!(
  [
    Minitest::Reporters::ProgressReporter.new,
    # Minitest::Reporters::DefaultReporter.new,
    # Minitest::Reporters::SpecReporter.new
  ],
  ENV,
  Minitest.backtrace_filter
)

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end
