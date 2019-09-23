source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'activerecord'
gem 'sqlite3', '~> 1.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
gem 'activemodel', '~> 6.0.0'

gem 'webpacker', '~> 4.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# MongoDB NoSQL database ORM
# gem 'mongoid',                  '~> 7.0'
gem 'mongoid',  git: 'https://github.com/mongodb/mongoid.git', branch: 'master'
gem 'mongoid-locker'

gem 'actiontext', '~> 6.0.0.rc1'
# Settings, validation and dependency injection
gem 'resource_registry',  git:  'https://github.com/ideacrew/resource_registry.git', branch: 'master'
gem 'fast_jsonapi'
gem 'roo', '~> 2.1.0'
gem 'dry-monads',               '~> 1.2'
gem 'dry-validation',           '~> 1.2'
gem 'dry-struct',               '~> 1.0'
gem 'dry-types',                '~> 1.0'
gem 'dry-initializer',          '~> 3.0'
gem 'nokogiri',                 '~> 1.10'
gem 'nokogiri-happymapper',     '~> 0.8.0', :require => 'happymapper'
gem 'money-rails',              '~> 1.13'
gem 'devise_token_auth'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'yard' #,                   '~> 0.9.12',  require: false
  gem 'climate_control' #
  gem 'factory_bot_rails',      '~> 4.11'
  gem 'pry-byebug'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console',            '>= 3'

  gem 'rubocop',                require: false
  gem 'rubocop-rspec'
  gem 'rubocop-git'
end
