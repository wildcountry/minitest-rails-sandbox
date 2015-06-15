ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

ActiveRecord::Migration.maintain_test_schema!
Capybara.default_driver = :rack_test

Minitest::Reporters.use!(
  [
    # Minitest::Reporters::ProgressReporter.new,
    # Minitest::Reporters::DefaultReporter.new,
    Minitest::Reporters::SpecReporter.new
  ],
  ENV,
  Minitest.backtrace_filter
)

Shoulda::Matchers.configure do |c|
  c.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end

module ActiveSupport
  class TestCase
    include FactoryGirl::Syntax::Methods

    infect_an_assertion :assert_difference, :must_change, :block
    infect_an_assertion :assert_no_difference, :wont_change, :block

    setup do
      ActionMailer::Base.deliveries.clear
    end

    teardown do
      Timecop.return
    end
  end
end

module ActionController
  class TestCase
    include Devise::TestHelpers
    include EmailSpec::Helpers
    include EmailSpec::Matchers

    alias_method :must_redirect_to, :assert_redirected_to
    alias_method :must_render_template, :assert_template

    setup do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end
  end
end

module ActionDispatch
  class IntegrationTest
    include Capybara::DSL
    include EmailSpec::Helpers
    include EmailSpec::Matchers

    class << self
      alias_method :context, :describe
      alias_method :scenario, :it
      alias_method :feature, :describe
    end

    setup do
      ## set page_size to 13-inch Macbook Air (if driver accepts resize() method)
      page.driver.try(:resize, 1440, 900)
    end

    teardown do
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end
  end
end
