# Clever Rails Templates

A set of Rails application templates optimized for modern development with comprehensive CI/CD, testing, and deployment setup.

## Quick Start (Recommended)

### Using the Wrapper Script

```bash
# API-only application
clever-rails new myapp api

# Fullstack application
clever-rails new myapp fullstack
```

The wrapper script automatically applies the correct flags:

- `--database=postgresql` (always)
- `--skip-kamal` (always)
- `--skip-test` (always - we use RSpec instead)
- `--api` (for API template only)

## Manual Usage

### API-only Template

```bash
rails new myapp --api --database=postgresql --skip-kamal --skip-test -m api_template.rb
```

### Fullstack Template

```bash
rails new myapp --database=postgresql --skip-kamal --skip-test -m fullstack_template.rb
```

## Features Included

### Both Templates

- ✅ **Latest Rails** with PostgreSQL database
- ✅ **Solid Queue** for background processing
- ✅ **RSpec** with FactoryBot and VCR for testing
- ✅ **GitHub Actions CI/CD** with security scanning, linting, and coverage
- ✅ **Code Coverage** reporting with SimpleCov
- ✅ **Security Scanning** with Brakeman
- ✅ **Code Linting** with RuboCop (Rails + RSpec rules)
- ✅ **Dependabot** for automated dependency updates
- ✅ **Heroku Deployment** ready (Procfile + app.json)
- ✅ **JSON:API** support with jsonapi-rails
- ✅ **Optional Doorkeeper** OAuth support
- ✅ **Optional CleverEventsRails** to add eventing

### Fullstack Template Additional Features

- ✅ **Hotwire** (Stimulus + Turbo) for modern frontend
- ✅ **Tailwind CSS** for styling
- ✅ **Site Prism** page objects for system testing
- ✅ **Capybara + Selenium** for browser testing

## Architecture

### Shared Modules (lib/)

The templates are built using reusable modules in the `lib/` directory:

- `gems.rb` - Gem management for base and fullstack apps
- `database.rb` - PostgreSQL configuration
- `solid_queue.rb` - Background job setup
- `rspec.rb` - Base RSpec configuration
- `rspec_fullstack.rb` - Extended RSpec with system tests
- `coverage.rb` - SimpleCov code coverage setup
- `rubocop.rb` - Code linting configuration
- `github_actions.rb` - Comprehensive CI/CD pipeline
- `heroku.rb` - Heroku deployment configuration
- `gitignore.rb` - Smart .gitignore setup
- `hotwire.rb` - Stimulus + Turbo configuration
- `tailwind.rb` - Tailwind CSS setup
- `cursor_rules.rb` - Cursor AI rules integration

### Benefits of Modular Architecture

- ✅ **DRY**: Shared functionality between templates
- ✅ **Maintainable**: Easy to update individual features
- ✅ **Extensible**: Simple to add new modules
- ✅ **Testable**: Each module can be tested independently

## CI/CD Pipeline

The GitHub Actions workflow includes:

1. **Security Scanning** - Brakeman static analysis
2. **Code Linting** - RuboCop style enforcement
3. **Testing** - Full RSpec test suite with dual PostgreSQL databases
4. **Coverage Reporting** - Automated coverage reports on PRs
5. **Dependency Management** - Dependabot for automated updates

## Deployment

### Heroku (Default)

Both templates include production-ready Heroku configuration:

- `Procfile` with web, worker, and release processes
- `app.json` with environment variables and addons
- Automatic database migrations on deploy

### Container Deployment

While Kamal is skipped by default, you can add container deployment later if needed.

## Prerequisites

- **Ruby** (via rbenv, asdf, or your preferred version manager)
- **PostgreSQL** (for database)
- **Node.js + Yarn** (for fullstack template only)

## Usage

### Quick Start

1. Make sure prerequisites are installed
2. Run: `./clever-rails new myapp api` or `./clever-rails new myapp fullstack`
3. Follow the setup instructions displayed after creation
4. Push to GitHub to trigger CI/CD pipeline
5. Deploy to Heroku using the included configuration

### Installation for Global Usage (Recommended)

#### Option 1: Automatic Installation (Easiest)

```bash
# Clone the repository
git clone https://github.com/your-org/clever-rails-template.git
cd clever-rails-template

# Run the installer
./install.sh
```

#### Option 2: Manual Installation

```bash
# From inside the clever-rails-template directory
ln -s $(pwd)/clever-rails /usr/local/bin/clever-rails
```

Once installed, you can use it from anywhere:

```bash
cd ~/Projects
clever-rails new myapp api
clever-rails new myapp fullstack
```

**Important**: Always run the command from the directory where you want to create your app, not from inside the template directory.

## Development

To modify or extend these templates:

1. Edit the relevant module in `lib/`
2. Test with the wrapper: `./clever-rails new test_app api`
3. The modular structure makes it easy to add new features or modify existing ones

## Support

These templates follow Clever's Rails conventions and best practices, including integration with cursor rules for consistent development standards.
