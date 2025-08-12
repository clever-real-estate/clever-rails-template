
%w[gems database solid_queue rspec rspec_fullstack coverage rubocop github_actions heroku gitignore hotwire tailwind cursor_rules].each do |lib|
  apply File.expand_path("lib/#{lib}.rb", __dir__)
end

def final_setup_fullstack
  empty_directory 'spec/factories'
  empty_directory 'spec/support/page_objects'

  create_file 'spec/factories/users.rb', <<~RUBY
    FactoryBot.define do
      factory :user do
        email { Faker::Internet.email }
        name { Faker::Name.name }
      end
    end
  RUBY

  create_file 'spec/support/page_objects/home_page.rb', <<~RUBY
    class HomePage < SitePrism::Page
      set_url '/'

      element :welcome_message, '[data-testid="welcome-message"]'
      element :name_input, '[data-controller="hello"] input[name="name"]'
      element :greet_button, '[data-controller="hello"] button'
      element :greeting_output, '[data-testid="greeting-output"]'
    end
  RUBY

  create_file 'spec/system/home_spec.rb', <<~RUBY
    require 'rails_helper'

    RSpec.describe 'Home page', type: :system do
      let(:home_page) { HomePage.new }

      before do
        home_page.load
      end

      it 'displays welcome message' do
        expect(home_page.welcome_message).to have_text('Welcome')
      end

      it 'greets user with Stimulus controller', js: true do
        home_page.name_input.set('World')
        home_page.greet_button.click

        expect(home_page.greeting_output).to have_text('Hello, World!')
      end
    end
  RUBY


  generate 'controller', 'Home', 'index'
  
  gsub_file 'app/controllers/home_controller.rb', /def index\s*end/m, <<~RUBY.chomp
    def index
      @message = "Welcome to your new Rails app!"
      @features = [
        { name: "Hotwire (Stimulus + Turbo)", emoji: "⚡" },
        { name: "Tailwind CSS", emoji: "🎨" },
        { name: "PostgreSQL", emoji: "🐘" },
        { name: "RSpec Testing", emoji: "🧪" },
        { name: "Solid Queue Jobs", emoji: "⚙️" },
        { name: "GitHub Actions", emoji: "🚀" }
      ]
    end
  RUBY

  gsub_file 'app/views/home/index.html.erb', /.+/m, <<~HTML.chomp
    <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 py-12">
      <div class="max-w-4xl mx-auto px-4">
        <div class="text-center mb-12">
          <h1 data-testid="welcome-message" class="text-4xl font-bold text-gray-900 mb-4">
            <%= @message %>
          </h1>
          <p class="text-xl text-gray-600">Built with modern Rails and awesome tools</p>
          <p class="text-sm text-gray-500 mt-2">Created by Engineering@Clever • Clever Real Estate</p>
        </div>

        <!-- Interactive Greeting Section -->
        <div data-controller="hello" class="bg-white rounded-lg shadow-lg p-8 mb-8">
          <h2 class="text-2xl font-semibold text-gray-800 mb-6">Try the Interactive Greeting</h2>
          <div class="flex flex-col sm:flex-row gap-4">
            <input 
              data-hello-target="name" 
              name="name" 
              type="text" 
              placeholder="Enter your name..." 
              class="flex-1 px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
            <button 
              data-action="click->hello#greet" 
              class="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors"
            >
              Say Hello!
            </button>
          </div>
          <div data-hello-target="output" data-testid="greeting-output" class="mt-4 text-lg font-medium text-blue-600 min-h-[2rem]"></div>
        </div>

        <!-- Features Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <% @features.each do |feature| %>
            <div class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow">
              <div class="text-3xl mb-3"><%= feature[:emoji] %></div>
              <h3 class="text-lg font-semibold text-gray-800"><%= feature[:name] %></h3>
            </div>
          <% end %>
        </div>

        <!-- Footer -->
        <div class="text-center mt-12">
          <p class="text-gray-600">Ready to build something amazing? 🚀</p>
        </div>
      </div>
    </div>
  HTML

  gsub_file 'config/routes.rb', /^\s*get ['"]home\/index['"].*\n/, ''
  route "root 'home#index'"
end

source_paths

add_fullstack_gems
add_oauth_gem
add_clever_events_gem

after_bundle do
  setup_solid_queue
  setup_database
  setup_hotwire
  setup_tailwind
  setup_rspec_fullstack
  setup_coverage
  setup_rubocop(include_assets_build: true)
  setup_github_actions
  setup_heroku_deployment(app_type: 'fullstack')
  setup_gitignore(include_tailwind: true)
  setup_cursor_rules
  final_setup_fullstack

  rails_command 'db:prepare'

  git :init
  git add: '.'
  git commit: "-m 'Initial commit with fullstack template setup'"

  puts "\n" + "="*60
  puts "🎉 Fullstack Rails application created successfully!"
  puts "="*60
  puts "\nNext steps:"
  puts "1. cd #{app_name}"
  puts "2. Make sure PostgreSQL is running"
  puts "3. Run: ./bin/dev (or rails server)"
  puts "4. Visit: http://localhost:3000"
  puts "5. Run tests with: bundle exec rspec"
  puts "6. Run system tests with: bundle exec rspec spec/system"
  puts "\nFeatures included:"
  puts "✅ Hotwire (Stimulus + Turbo)"
  puts "✅ Tailwind CSS"
  puts "✅ RSpec with system tests"
  puts "✅ Site Prism page objects"
  puts "✅ Solid Queue background jobs"
  puts "✅ PostgreSQL database"
  puts "✅ JSON:API serializer"
  puts "✅ GitHub Actions CI/CD"
  puts "✅ Code coverage reporting"
  puts "✅ Security scanning with Brakeman"
  puts "✅ Code linting with RuboCop"
  puts "✅ Dependabot for automated updates"
  puts "✅ Heroku deployment ready (Procfile + app.json)"
  puts "\nHappy coding! 🚀"
end
