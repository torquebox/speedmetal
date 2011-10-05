# TorqueBox Setup

Install prerequisite gems

    cd /mnt/data/speedmetal/apps/rails3/spree
    jruby -S bundle install

Migrate database and load default data

    sudo yum install -y ImageMagick
    RAILS_ENV=production jruby -S rake db:bootstrap

When prompted to load sample data during db:bootstrap, choose yes.

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



# TorqueBox 1.x Setup

Install prerequisite gems

    cd /mnt/data/speedmetal/apps/rails3/spree
    jruby -S bundle install

Migrate database and load default data

    sudo yum install -y ImageMagick
    RAILS_ENV=production jruby -S rake db:bootstrap

When prompted to load sample data during db:bootstrap, choose yes.

Create a deployment descriptor

    rm -f $JBOSS_HOME/server/default/deploy/*-knob.yml
    cat << EOF > $JBOSS_HOME/server/default/deploy/spree-knob.yml
    ---
    application:
      root: /mnt/data/speedmetal/apps/rails3/spree/
      env: production
    web:
      context: /
    EOF

Edit $JBOSS_HOME/server/default/deploy/jbossweb.sar/server.xml and add
maxThreads="100" to the port 8080 HTTP connector element.

Start TorqueBox

    screen
    $JBOSS_HOME/bin/run.sh -b 0.0.0.0



# Trinidad Setup

Install prerequisite gems

    cd /mnt/data/speedmetal/apps/rails3/spree
    jruby -S gem install bundler
    jruby -S bundle install

Migrate database and load default data

    sudo yum install -y ImageMagick
    RAILS_ENV=production jruby -S rake db:bootstrap

When prompted to load sample data during db:bootstrap, choose yes.

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

    sudo yum install -y ImageMagick
    RAILS_ENV=production rake db:bootstrap

When prompted to load sample data during db:bootstrap, choose yes.

Start Passenger

    screen
    passenger start -p 8080 -e production --max-pool-size 50



# Unicorn Setup

Install prerequisite gems

    sudo yum install -y mysql-libs mysql-devel sqlite-devel
    cd /mnt/data/speedmetal/apps/rails3/spree
    sudo gem install bundler
    bundle install

Migrate database and load default data

    sudo yum install -y ImageMagick
    RAILS_ENV=production rake db:bootstrap

When prompted to load sample data during db:bootstrap, choose yes.

Write config file

    cat << EOF > /tmp/unicorn.rb
    worker_processes 50
    preload_app true
    timeout 30
    listen 8080, :backlog => 2048

    # REE-friendly
    if GC.respond_to?(:copy_on_write_friendly=)
      GC.copy_on_write_friendly = true
    end

    before_fork do |server, worker|
      ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
    end

    after_fork do |server, worker|
      ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
    end
    EOF

Start Unicorn

    screen
    unicorn_rails -E production -c /tmp/unicorn.rb



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
