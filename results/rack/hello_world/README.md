# TorqueBox Setup

## Create TorqueBox deployment descriptor
    rm -f $JBOSS_HOME/server/default/deploy/*-knob.yml
    cat << EOF > $JBOSS_HOME/server/default/deploy/hello-knob.yml  
    ---  
    application:  
      root: /home/ec2-user/speedmetal/apps/rack/hello_world/  
      env: production  
    web:  
      context: /hello  
    EOF

## Start TorqueBox
    $JBOSS_HOME/bin/run.sh -b 0.0.0.0


# Passenger Setup

## Copy app to /tmp
Passenger needs the nginx workers that run as the 'nobody' user
to have access to the application.
    rm -rf /tmp/hello_world/
    cp -r speedmetal/apps/rack/hello_world/ /tmp/

## Make public directory
Passenger expects all apps to have a public/ directory
    cd /tmp/hello_world
    mkdir public

## Start Passenger
    passenger start -p 8080 -e production


# Thin Setup

## Start Thin
    cd speedmetal/apps/rack/hello_world/  
    thin -p 8080 -e production start


# Trinidad Setup

## Start Trinidad
    cd speedmetal/apps/rack/hello_world/  
    jruby -S trinidad -r -p 8080 -e production -t
