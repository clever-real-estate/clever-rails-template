def setup_rspec
  create_file '.rspec', <<~TEXT
    --require spec_helper
    --format documentation
    --color
  TEXT

  empty_directory 'spec'
  
  create_file 'spec/spec_helper.rb', <<~RUBY
    require 'vcr'
    require 'webmock/rspec'

    RSpec.configure do |config|
      config.expect_with :rspec do |expectations|
        expectations.include_chain_clauses_in_custom_matcher_descriptions = true
      end

      config.mock_with :rspec do |mocks|
        mocks.verify_partial_doubles = true
      end

      config.shared_context_metadata_behavior = :apply_to_host_groups
      config.filter_run_when_matching :focus
      config.example_status_persistence_file_path = "spec/examples.txt"
      config.disable_monkey_patching!
      config.warnings = true

      if config.files_to_run.one?
        config.default_formatter = "doc"
      end

      config.profile_examples = 10
      config.order = :random
      Kernel.srand config.seed
    end

    VCR.configure do |config|
      config.cassette_library_dir = "spec/vcr_cassettes"
      config.hook_into :webmock
      config.configure_rspec_metadata!
      config.allow_http_connections_when_no_cassette = false
    end
  RUBY

  create_file 'spec/rails_helper.rb', <<~RUBY
    require 'spec_helper'
    ENV['RAILS_ENV'] ||= 'test'
    require_relative '../config/environment'
    abort("The Rails environment is running in production mode!") if Rails.env.production?
    require 'rspec/rails'

    begin
      ActiveRecord::Migration.maintain_test_schema!
    rescue ActiveRecord::PendingMigrationError => e
      abort e.to_s.strip
    end

    RSpec.configure do |config|
      config.include FactoryBot::Syntax::Methods
      config.fixture_path = Rails.root.join('spec/fixtures')
      config.use_transactional_fixtures = true
      config.infer_spec_type_from_file_location!
      config.filter_rails_from_backtrace!
    end
  RUBY
end