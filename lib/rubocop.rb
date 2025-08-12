def setup_rubocop(include_assets_build: false)
  excludes = [
    "- 'bin/**/*'",
    "- 'db/schema.rb'",
    "- 'db/migrate/**/*'",
    "- 'vendor/**/*'",
    "- 'node_modules/**/*'"
  ]
  
  if include_assets_build
    excludes << "- 'app/assets/builds/**/*'"
  end

  create_file '.rubocop.yml', <<~YAML
    require:
      - rubocop-rails
      - rubocop-rspec

    AllCops:
      NewCops: enable
      TargetRubyVersion: 3.2
      Exclude:
        #{excludes.join("\n        ")}

    Style/Documentation:
      Enabled: false

    Metrics/BlockLength:
      Exclude:
        - 'spec/**/*'
        - 'config/routes.rb'
  YAML
end