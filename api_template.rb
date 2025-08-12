
%w[gems database solid_queue rspec coverage rubocop github_actions heroku gitignore].each do |lib|
  apply File.expand_path("lib/#{lib}.rb", __dir__)
end

def final_setup_api
  empty_directory 'spec/factories'
  
  create_file 'spec/factories/foo_bars.rb', <<~RUBY
    FactoryBot.define do
      factory :foo_bar do
        whizbang { "#{['super', 'turbo', 'mega', 'ultra', 'hyper'].sample}-whiz" }
        doodad { "#{['awesome', 'fantastic', 'spectacular', 'amazing'].sample}-doodad" }
        snazzy_level { rand(1000..9999) }
      end
    end
  RUBY

  create_file 'spec/requests/api/v1/health_check_spec.rb', <<~RUBY
    require 'rails_helper'

    RSpec.describe 'API::V1::HealthCheck', type: :request do
      describe 'GET /api/v1/health' do
        it 'returns success status' do
          get '/api/v1/health'
          
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to include('status' => 'ok')
        end
      end
    end
  RUBY

  create_file 'app/controllers/api/v1/health_check_controller.rb', <<~RUBY
    class Api::V1::HealthCheckController < ApplicationController
      def index
        render json: { status: 'ok', timestamp: Time.current }
      end
    end
  RUBY

  create_file 'app/models/foo_bar.rb', <<~RUBY
    class FooBar
      attr_accessor :id, :whizbang, :doodad, :snazzy_level, :created_at

      def initialize(id, whizbang, doodad, snazzy_level, created_at)
        @id = id
        @whizbang = whizbang
        @doodad = doodad
        @snazzy_level = snazzy_level
        @created_at = Time.parse(created_at)
      end

      def self.all
        [
          new(1, 'super-whiz', 'mega-doodad', 9001, '2024-01-15'),
          new(2, 'turbo-whiz', 'ultra-doodad', 8500, '2024-02-20'),
          new(3, 'hyper-whiz', 'giga-doodad', 7200, '2024-03-10')
        ]
      end

      def self.find(id)
        all.find { |foo_bar| foo_bar.id == id.to_i }
      end
    end
  RUBY

  create_file 'app/controllers/api/v1/foo_bars_controller.rb', <<~RUBY
    class Api::V1::FooBarsController < ApplicationController
      def index
        foo_bars = FooBar.all
        render jsonapi: foo_bars
      end

      def show
        foo_bar = FooBar.find(params[:id])
        
        if foo_bar
          render jsonapi: foo_bar
        else
          render json: { error: 'FooBar not found' }, status: :not_found
        end
      end
    end
  RUBY

  create_file 'app/serializers/serializable_foo_bar.rb', <<~RUBY
    class SerializableFooBar < JSONAPI::Serializable::Resource
      type :foo_bars

      attributes :whizbang, :doodad, :snazzy_level, :created_at

      attribute :id do
        @object.id
      end
    end
  RUBY

  route 'namespace :api do
    namespace :v1 do
      get :health, to: "health_check#index"
      resources :foo_bars, only: [:index, :show]
    end
  end'
end

source_paths

add_base_gems
add_oauth_gem
add_clever_events_gem

after_bundle do
  setup_solid_queue
  setup_database
  setup_rspec
  setup_coverage
  setup_rubocop
  setup_github_actions
  setup_heroku_deployment(app_type: 'api')
  setup_gitignore
  final_setup_api

  rails_command 'db:prepare'
  
  git :init
  git add: '.'
  git commit: "-m 'Initial commit with API template setup'"

  puts "\n" + "="*60
  puts "🎉 API-only Rails application created successfully!"
  puts "="*60
  puts "\nNext steps:"
  puts "1. cd #{app_name}"
  puts "2. Make sure PostgreSQL is running"
  puts "3. Run: rails server"
  puts "4. Test endpoints:"
  puts "   Health: curl http://localhost:3000/api/v1/health"
  puts "   FooBars: curl http://localhost:3000/api/v1/foo_bars"
  puts "5. Run tests with: bundle exec rspec"
  puts "\nFeatures included:"
  puts "✅ RSpec with FactoryBot and VCR"
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