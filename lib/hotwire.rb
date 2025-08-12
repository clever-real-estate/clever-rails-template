def setup_hotwire
  rails_command 'javascript:install:esbuild'

  remove_file 'package-lock.json' if File.exist?('package-lock.json')

  run 'yarn add @hotwired/stimulus @hotwired/turbo-rails'

  rails_command 'stimulus:install'
  rails_command 'turbo:install'

  gsub_file 'app/javascript/application.js', 'import "controllers"', 'import "./controllers"'

  package_json = JSON.parse(File.read('package.json'))
  package_json['scripts'] ||= {}
  package_json['scripts']['build:js'] = 'esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds --public-path=/assets'
  package_json['scripts']['build:css'] = 'tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css'
  package_json['scripts']['dev:js'] = 'esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds --public-path=/assets --watch'
  package_json['scripts']['dev:css'] = 'tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --watch'

  File.write('package.json', JSON.pretty_generate(package_json))

  say "✅ esbuild + Yarn configured for fast JavaScript bundling"
end
