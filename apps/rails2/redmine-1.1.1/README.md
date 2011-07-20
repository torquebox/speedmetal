# TorqueBox Setup

Install prerequisite gems

    jruby -S gem install -v=0.4.2 i18n
    jruby -S gem install -v=1.0.1 rack
    jruby -S gem install -v=2.3.8 rails
    jruby -S gem install -v=0.9.7 activerecord-jdbcmysql-adapter

Migrate database and load default data

    cd /mnt/data/speedmetal/apps/rails2/redmine-1.1.1
    RAILS_ENV=production jruby -S rake db:migrate
    RAILS_ENV=production REDMINE_LANG=en jruby -S rake redmine:load_default_data

Create a deployment descriptor

    rm -f $JBOSS_HOME/standalone/deployments/*-knob.yml
    cat << EOF > $JBOSS_HOME/standalone/deployments/redmine-knob.yml
    ---
    application:
      root: /mnt/data/speedmetal/apps/rails2/redmine-1.1.1/
      env: production
    web:
      context: /
    EOF

Edit $JBOSS_HOME/server/default/deploy/jbossweb.sar/server.xml and add
`maxThreads="100"` to the port 8080 HTTP connector element.

Start TorqueBox

    screen
    $JBOSS_HOME/bin/standalone.sh -b 0.0.0.0



# Trinidad Setup

Install prerequisite gems

    jruby -S gem install -v=0.4.2 i18n
    jruby -S gem install -v=1.0.1 rack
    jruby -S gem install -v=0.9.7 activerecord-jdbcmysql-adapter

Migrate database and load default data

    cd /mnt/data/speedmetal/apps/rails2/redmine-1.1.1
    RAILS_ENV=production jruby -S rake db:migrate
    RAILS_ENV=production REDMINE_LANG=en jruby -S rake redmine:load_default_data

## Write Trinidad Config File

    cat << EOF > /tmp/trinidad.yml
    ---
    http:
      maxThreads: 100
    EOF

Start Trinidad

    screen
    jruby -J-Xmx2048m -S trinidad -p 8080 -e production -t --config /tmp/trinidad.yml



# GlassFish Setup

Install prerequisite gems

    jruby -S gem install -v=0.4.2 i18n
    jruby -S gem install -v=1.0.1 rack
    jruby -S gem uninstall -v=1.2.1 rack
    jruby -S gem install -v=0.9.7 activerecord-jdbcmysql-adapter

Migrate database and load default data

    cd /mnt/data/speedmetal/apps/rails2/redmine-1.1.1
    RAILS_ENV=production jruby -S rake db:migrate
    RAILS_ENV=production REDMINE_LANG=en jruby -S rake redmine:load_default_data

Create GlassFish config file

    jruby -S gfrake config
    sed -i 's/port: 3000/port: 8080/' config/glassfish.yml
    sed -i 's/environment: development/environment: production/' config/glassfish.yml
    sed -i 's/max-thread-pool-size: 5/max-thread-pool-size: 100/' config/glassfish.yml
    
Start GlassFish

    jruby -J-Xmx2048m -S glassfish



# Passenger Setup

Install prerequisite gems

    sudo gem install -v=0.4.2 i18n
    sudo gem install -v=1.0.1 rack
    sudo gem uninstall -v=1.2.1 rack
    sudo yum install -y mysql-libs mysql-devel
    sudo gem install mysql

Migrate database and load default data

    cd /mnt/data/speedmetal/apps/rails2/redmine-1.1.1
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production REDMINE_LANG=en rake redmine:load_default_data

Start Passenger

    screen
    passenger start -p 8080 -e production --max-pool-size 18



# Unicorn Setup

Install prerequisite gems

    sudo gem install -v=0.4.2 i18n
    sudo gem install -v=1.0.1 rack
    sudo gem uninstall -v=1.2.1 rack
    sudo yum install -y mysql-libs mysql-devel
    sudo gem install mysql

Migrate database and load default data

    cd /mnt/data/speedmetal/apps/rails2/redmine-1.1.1
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production REDMINE_LANG=en rake redmine:load_default_data

Write config file

    cat << EOF > /tmp/unicorn.rb
    worker_processes 18
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

    unicorn_rails -E production -c /tmp/unicorn.rb


# Thin Setup

Install prerequisite gems

    sudo gem install -v=0.4.2 i18n
    sudo gem install -v=1.0.1 rack
    sudo gem uninstall -v=1.2.1 rack
    sudo yum install -y mysql-libs mysql-devel
    sudo gem install mysql

Migrate database and load default data

    cd /mnt/data/speedmetal/apps/rails2/redmine-1.1.1
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production REDMINE_LANG=en rake redmine:load_default_data

Start thin

    thin -p 8080 -e production start



# Run Benchmark

From Tsung machine, test app is running via curl

    curl http://server:8080/

Then verify you can ssh into the server and localhost without a
password

    ssh server
    ssh localhost

Finally, kick off the benchmark

    screen
    tsung -f /home/ec2-user/speedmetal/apps/rails2/redmine-1.1.1/tsung.xml start
