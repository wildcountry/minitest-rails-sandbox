require 'test_helper'

class FactoryLintTest < ActiveSupport::TestCase
  it 'lints the factories' do
    FactoryGirl.lint
  end
end
