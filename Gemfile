source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'rails', '6.1.7.10'
# gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
gem 'pg', '~> 1.1' # Use postgresql for Active Record
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '>= 4.0'
gem 'turbolinks', '~> 5' #Navigates web app faster with this
gem 'jbuilder', '~> 2.7' #build JSON
gem 'twilio-ruby' #SMS, MMS and RCS via an API

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'bootsnap', '>= 1.4.4', require: false # Reduces boot times by caching

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw] #debugger
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
