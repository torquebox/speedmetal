# TorqueBox Setup

## Create TorqueBox deployment descriptor
    rm -f $JBOSS_HOME/server/default/deploy/*-knob.yml
    cat << EOF > $JBOSS_HOME/server/default/deploy/sleep-knob.yml
    ---  
    application:  
      root: /home/ec2-user/speedmetal/apps/rack/sleep/
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
    rm -rf /tmp/sleep/
    cp -r speedmetal/apps/rack/sleep/ /tmp/

## Make public directory
Passenger expects all apps to have a public/ directory
    cd /tmp/sleep/
    mkdir public

## Start Passenger

For this test we need to update the default passenger standalone max
pool size from 6 to the number of concurrent clients our test
uses. So, 25, 50, 100, etc.

    passenger start -p 8080 -e production --max-pool-size <concurrency of test>


# Thin Setup

## Start Thin
    cd speedmetal/apps/rack/sleep/
    thin -p 8080 -e production start


# Trinidad Setup

## Start Trinidad
    cd speedmetal/apps/rack/sleep/
    jruby -S trinidad -r -p 8080 -e production -t


# Unicorn Setup

## Write Config File
Replace worker_processes below with the number of concurrent clients
in the test.

    cat << EOF > /tmp/unicorn.rb
    worker_processes 100
    preload_app true
    timeout 30
    listen 8080, :backlog => 2048
    EOF

## Start Unicorn
  cd speedmetal/apps/rack/sleep/
  RACK_ENV=production unicorn -c /tmp/unicorn.rb
