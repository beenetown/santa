source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.0.0'
gem 'bcrypt-ruby', '3.0.1'
gem 'omniauth-amazon'
gem 'omniauth-facebook'
# gem 'omniauth-google'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'


gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

gem 'whenever', require: false

gem 'faker', '~> 1.3.0'

group :test do
  gem 'rspec-rails', '2.13.1'
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'spork-rails', '4.0.0'
  gem 'factory_girl_rails', '4.2.1'
  gem 'guard-spork'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'sqlite3'
  # gem 'terminal-notifier-guard', '1.5.3'
  gem 'terminal-notifier-guard', github: 'elbii/terminal-notifier-guard', branch: :check_path
  gem 'guard-rspec', '2.5.0'
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end