def setup_coverage
  create_file '.simplecov', <<~RUBY
    require 'simplecov-cobertura'

    SimpleCov.start 'rails' do
      if ENV['CI']
        formatter SimpleCov::Formatter::MultiFormatter.new([
          SimpleCov::Formatter::HTMLFormatter,
          SimpleCov::Formatter::CoberturaFormatter
        ])
      end
      
      add_filter '/spec/'
      add_filter '/config/'
      add_filter '/vendor/'
      add_filter '/db/'
    end
  RUBY
end