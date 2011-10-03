# Common Setup

Install ImageMagick

    sudo yum install -y ImageMagick

# TorqueBox Setup

Install prerequisite gems

    cd /mnt/data/speedmetal/apps/rails3/spree
    jruby -S bundle install

Migrate database and load default data

    RAILS_ENV=production jruby -S rake db:bootstrap

Create a deployment descriptor

    rm -f $JBOSS_HOME/standalone/deployments/*-knob*
    cat << EOF > $JBOSS_HOME/standalone/deployments/spree-knob.yml
    ---
    application:
      root: /mnt/data/speedmetal/apps/rails3/spree/
      env: production
    web:
      context: /
    EOF
    touch $JBOSS_HOME/standalone/deployments/spree-knob.yml.dodeploy

Start TorqueBox

    screen
    $JBOSS_HOME/bin/standalone.sh -Djboss.bind.address=0.0.0.0 -Dorg.torquebox.web.http.maxThreads=100



# Trinidad Setup

Install prerequisite gems

    cd /mnt/data/speedmetal/apps/rails3/spree
    jruby -S gem install bundler
    jruby -S bundle install

Migrate database and load default data

    RAILS_ENV=production jruby -S rake db:bootstrap

## Write Trinidad Config File

    cat << EOF > /tmp/trinidad.yml
    ---
    http:
      maxThreads: 100
    EOF

Start Trinidad

    screen
    jruby -J-Xmx2048m -S trinidad -p 8080 -e production -t --config /tmp/trinidad.yml



# Passenger Setup

Install prerequisite gems

    sudo yum install -y mysql-libs mysql-devel sqlite-devel
    cd /mnt/data/speedmetal/apps/rails3/spree
    sudo gem install bundler
    bundle install

Migrate database and load default data

    RAILS_ENV=production rake db:bootstrap

Start Passenger

    screen
    passenger start -p 8080 -e production --max-pool-size 50



# Run Benchmark

From Tsung machine, test app is running via curl

    curl http://server:8080/

Then verify you can ssh into the server and localhost without a
password

    ssh server
    ssh localhost

Finally, kick off the benchmark

    screen
    tsung -f /home/ec2-user/speedmetal/apps/rails3/spree/tsung.xml start
