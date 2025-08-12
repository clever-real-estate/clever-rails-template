def setup_solid_queue
  rails_command 'generate solid_queue:install'
  
  inject_into_file 'config/environments/development.rb', before: /^end/ do
    <<~RUBY

      config.active_job.queue_adapter = :solid_queue
      config.solid_queue.connects_to = { database: { writing: :primary, reading: :primary } }
    RUBY
  end

  inject_into_file 'config/environments/test.rb', before: /^end/ do
    <<~RUBY

      config.active_job.queue_adapter = :solid_queue
      config.solid_queue.connects_to = { database: { writing: :primary, reading: :primary } }
    RUBY
  end
end