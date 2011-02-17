# Copy app to /tmp
Passenger needs the nginx workers that run as the 'nobody' user
to have access to the application.
    cp -r speedmetal/apps/rails3/hello_world/ /tmp/

# Install needed gems
    gem install bundler
    cd /tmp/hello_world
    bundle install

# Start Passenger
    RACK_ENV=production passenger start -p 8080
