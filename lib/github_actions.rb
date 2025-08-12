def setup_github_actions
  empty_directory '.github/workflows'
  
  create_file '.github/workflows/ci.yml', <<~YAML
    name: CI

    on:
      pull_request:
        branches:
          - "*"
      push:
        branches:
          - main
          - staging

    env:
      CI: true

    jobs:
      scan_ruby:
        runs-on: ubuntu-latest

        steps:
          - name: Checkout code
            uses: actions/checkout@v4

          - name: Set up Ruby
            uses: ruby/setup-ruby@v1
            with:
              ruby-version: .ruby-version
              bundler-cache: true

          - name: Scan for common Rails security vulnerabilities using static analysis
            run: bin/brakeman --no-pager

      lint:
        runs-on: ubuntu-latest
        steps:
          - name: Checkout code
            uses: actions/checkout@v4

          - name: Set up Ruby
            uses: ruby/setup-ruby@v1
            with:
              ruby-version: .ruby-version
              bundler-cache: true

          - name: Lint code for consistent style
            run: bundle exec rubocop -f github

      test:
        runs-on: ubuntu-latest
        services:
          postgres:
            image: postgres:16.4
            env:
              POSTGRES_DB: #{app_name}_test
              POSTGRES_USER: postgres
              POSTGRES_PASSWORD: postgres
            ports: ["5432:5432"]
            options: >-
              --health-cmd pg_isready
              --health-interval 10s
              --health-timeout 5s
              --health-retries 5
          postgres_solid:
            image: postgres:16.4
            env:
              POSTGRES_DB: #{app_name}_queue_test
              POSTGRES_USER: postgres
              POSTGRES_PASSWORD: postgres
            ports: ["5433:5432"]
            options: >-
              --health-cmd pg_isready
              --health-interval 10s
              --health-timeout 5s
              --health-retries 5

        steps:
          - name: Checkout code
            uses: actions/checkout@v4

          - name: Set up Ruby
            uses: ruby/setup-ruby@v1
            with:
              ruby-version: .ruby-version
              bundler-cache: true

          - name: Install dependencies
            run: bundle exec bundle install --jobs 4 --retry 3

          - name: Install system dependencies
            if: ${{ contains(github.event.head_commit.message, 'fullstack') || github.repository_name == '*fullstack*' }}
            run: |
              sudo apt-get update
              sudo apt-get install --no-install-recommends libvips

          - name: Precompile assets
            if: ${{ contains(github.event.head_commit.message, 'fullstack') || github.repository_name == '*fullstack*' }}
            run: bundle exec rails assets:precompile
            env:
              DATABASE_URL: "postgres://postgres:postgres@localhost:\\${{ job.services.postgres.ports[5432] }}/#{app_name}_test"
              QUEUE_DATABASE_URL: "postgres://postgres:postgres@localhost:\\${{ job.services.postgres_solid.ports[5432] }}/#{app_name}_queue_test"

          - name: Run tests
            run: bundle exec rspec
            env:
              DATABASE_URL: "postgres://postgres:postgres@localhost:\\${{ job.services.postgres.ports[5432] }}/#{app_name}_test"
              QUEUE_DATABASE_URL: "postgres://postgres:postgres@localhost:\\${{ job.services.postgres_solid.ports[5432] }}/#{app_name}_queue_test"

          - name: Code Coverage Report
            uses: irongut/CodeCoverageSummary@v1.3.0
            if: \\${{ github.actor != 'dependabot[bot]' }}
            with:
              filename: ./coverage/coverage.xml
              badge: true
              hide_branch_rate: true
              hide_complexity: true
              format: markdown
              indicators: true
              output: file

          - name: Add Coverage PR Comment
            uses: marocchino/sticky-pull-request-comment@v2
            if: \\${{ github.event_name == 'pull_request' && github.actor != 'dependabot[bot]' }}
            with:
              recreate: true
              path: code-coverage-results.md
  YAML

  create_file '.github/dependabot.yml', <<~YAML
    version: 2
    updates:
      - package-ecosystem: bundler
        directory: "/"
        schedule:
          interval: daily
          time: "10:00"
        open-pull-requests-limit: 10
      - package-ecosystem: "github-actions"
        directory: "/"
        schedule:
          interval: "daily"
          time: "10:00"
        open-pull-requests-limit: 10
  YAML

  create_file 'bin/brakeman', <<~RUBY
    #!/usr/bin/env ruby
    frozen_string_literal: true

    require 'bundler/setup'
    require 'brakeman'

    exit Brakeman.run(
      app_path: '.',
      print_report: true,
      ensure_latest: true
    )
  RUBY

  chmod 'bin/brakeman', 0755
end