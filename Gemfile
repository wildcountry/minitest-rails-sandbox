source 'https://rubygems.org'

ruby '2.2.2'

gem 'bundler', '>= 1.7.12' # Heroku currently uses Bundler v1.7.12
gem 'rails', '4.2.1'

gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks', github: 'rails/turbolinks' # Use master branch, until v3+ is released

gem 'devise'

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'guard'
end

group :test do
  gem 'minitest-spec-rails'
  gem 'guard-minitest'
  gem 'database_cleaner'
  gem 'minitest-reporters'
  gem 'minitest-fail-fast'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'shoulda'
  gem 'shoulda-matchers', github: 'thoughtbot/shoulda-matchers'
end
