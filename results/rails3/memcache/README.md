# Special Instructions

Make sure to restart memcached between each test so all tests are
starting from an empty cache.

# Install Gems
    jruby -S gem install bundler
    cd speedmetal/apps/rails3/memcache
    jruby -S bundle install
    gem install bundler
    bundle install


# TorqueBox Setup

## Create TorqueBox deployment descriptor
    rm -f $JBOSS_HOME/server/default/deploy/*-knob.yml
    cat << EOF > $JBOSS_HOME/server/default/deploy/memcache-knob.yml
    ---
    application:
      root: /home/ec2-user/speedmetal/apps/rails3/memcache/
      env: production
    web:
      context: /
    EOF
## Start TorqueBox
    $JBOSS_HOME/bin/run.sh -b 0.0.0.0


# Passenger Setup

## Copy app to /tmp
Passenger needs the nginx workers that run as the 'nobody' user
to have access to the application.
    rm -rf /tmp/memcache/
    cp -r speedmetal/apps/rails3/memcache/ /tmp/

## Start Passenger
    cd /tmp/memcache/
    passenger start -p 8080 -e production --max-pool-size N


# Thin Setup

## Start Thin
    cd speedmetal/apps/rails3/memcache/
    thin -p 8080 -e production start


# Trinidad Setup

## Start Trinidad
    cd speedmetal/apps/rails3/memcache/
    jruby -S trinidad -r -p 8080 -e production -t


# Unicorn Setup

## Write Config File
    cat << EOF > /tmp/unicorn.rb
    worker_processes N
    preload_app true
    timeout 30
    listen 8080, :backlog => 2048
    EOF

## Start Unicorn
    cd speedmetal/apps/rails3/memcache/
    unicorn_rails -E production -c /tmp/unicorn.rb
