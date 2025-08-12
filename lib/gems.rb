def add_base_gems
  
  gem_group :development, :test do
    gem 'rspec-rails'
    gem 'factory_bot_rails'
    gem 'vcr'
    gem 'webmock'
    gem 'pry-rails'
    gem 'pry-byebug'
    gem 'faker'
    gem 'simplecov', require: false
    gem 'simplecov-cobertura', require: false
    gem 'jsonapi-rspec'
  end
  
  gem_group :development do
    gem 'rubocop', require: false
    gem 'rubocop-rails', require: false
    gem 'rubocop-rspec', require: false
    gem 'brakeman', require: false
  end

  gem 'solid_queue'
  gem 'jsonapi-rails', git: 'https://github.com/jsonapi-rb/jsonapi-rails', branch: 'master'
end


def add_fullstack_gems
  add_base_gems
  
  gem_group :development, :test do
    gem 'site_prism'
    gem 'selenium-webdriver'
    gem 'capybara'
  end

  gem 'tailwindcss-rails'
end

def add_oauth_gem
  if yes?('Do you need OAuth support with Doorkeeper? (y/n)')
    gem 'doorkeeper'
  end
end

def add_clever_events_gem
  if yes?('Do you want to include CleverEventsRails to add eventing? (y/n)')
    gem 'clever_events_rails', git: 'https://github.com/clever-real-estate/clever-events-rails'
  end
end