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

Shoulda::Matchers.configure do |c|
  c.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end

# rubocop:disable Style/ClassAndModuleChildren
class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  infect_an_assertion :assert_difference, :must_change, :block
  infect_an_assertion :assert_no_difference, :wont_change, :block

  teardown do
    Timecop.return
  end
end

class ActionController::TestCase
  include Devise::TestHelpers

  alias_method :must_redirect_to, :assert_redirected_to
  alias_method :must_render_template, :assert_template

  setup do
    ActionMailer::Base.deliveries.clear
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
end
