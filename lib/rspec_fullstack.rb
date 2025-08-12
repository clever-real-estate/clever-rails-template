def setup_rspec_fullstack
  setup_rspec
  
  gsub_file 'spec/rails_helper.rb', /RSpec\.configure do \|config\|.*config\.include FactoryBot::Syntax::Methods/m do |match|
    <<~RUBY
      #{match}
      
      config.before(:each, type: :system) do
        driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
      end
    RUBY
  end

  create_file 'spec/support/system_spec_helper.rb', <<~RUBY
    require 'capybara/rspec'
    require 'selenium/webdriver'

    Capybara.register_driver :selenium_chrome_headless do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')
      options.add_argument('--window-size=1400,1400')

      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    end

    Capybara.javascript_driver = :selenium_chrome_headless
    Capybara.default_max_wait_time = 5
  RUBY
end