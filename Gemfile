ruby '2.3.3'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use something better than ERB
gem 'haml', '~> 4.0.0'
gem 'haml-rails', '~> 0.9.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Frontend gemmery:
gem 'select2-rails', '~> 4.0.3'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use Devise and CanCan for auth{z,n}
gem 'devise', '~> 4.2.0'
gem 'cancan', '~> 1.6.10'
# Render that markdown
gem 'redcarpet', '~> 3.0.0'
# Handle image attachment
gem 'paperclip', '~> 5.0.0'
gem 'aws-sdk', '~> 2.6.0'
# Friendly URL paths
gem 'friendly_id', '~> 5.1.0'
# Filter and sort
gem 'filterrific', '~> 2.1.2'
# Pagination
gem 'will_paginate', '~> 3.1.0'
gem 'will_paginate-bootstrap', '~> 1.0.0'
# Taggables
gem 'acts-as-taggable-on', '~> 4.0'
# Full-text search
gem 'pg_search', '~> 2.0.1'
# Meta tags
gem 'meta-tags', '~> 2.4.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'rails-controller-testing', '~> 1.0.1'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'simplecov', '~> 0.12.0'
  gem 'simplecov-console', '~> 0.3.1'
  gem 'rubocop', '~> 0.46.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
