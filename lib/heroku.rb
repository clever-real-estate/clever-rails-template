def setup_heroku_deployment(app_type: 'api')
  description = case app_type
                when 'fullstack'
                  "Rails fullstack application with Hotwire and Solid Queue"
                else
                  "Rails API application with Solid Queue"
                end

  create_file 'Procfile', <<~TEXT
    release: bundle exec rake db:migrate
    web: bundle exec rails server
    worker: bundle exec solid_queue:start
  TEXT
  
  create_file 'app.json', <<~JSON
    {
      "name": "#{app_name}",
      "description": "#{description}",
      "scripts": {
        "postdeploy": "bundle exec rake db:migrate db:seed"
      },
      "env": {
        "RAILS_ENV": {
          "value": "production"
        },
        "RAILS_SERVE_STATIC_FILES": {
          "value": "true"
        },
        "RAILS_LOG_TO_STDOUT": {
          "value": "true"
        }
      },
      "formation": {
        "web": {
          "quantity": 1,
          "size": "basic"
        },
        "worker": {
          "quantity": 1,
          "size": "basic"
        }
      },
      "addons": [
        "heroku-postgresql"
      ],
      "buildpacks": [
        {
          "url": "heroku/ruby"
        }
      ]
    }
  JSON
end