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
    passenger start -p 8080 -e production


# Thin Setup

## Start Thin
    cd speedmetal/apps/rack/sleep/
    thin -p 8080 -e production start


# Trinidad Setup

## Start Trinidad
    cd speedmetal/apps/rack/sleep/
    jruby -S trinidad -r -p 8080 -e production -t
