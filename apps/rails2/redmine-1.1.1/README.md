# TorqueBox Setup

Install prerequisite gems

    jruby -S gem install -v=0.4.2 i18n
    jruby -S gem install -v=1.0.1 rack
    jruby -S gem install -v=0.9.7 activerecord-jdbcmysql-adapter

Migrate database and load default data

    cd /mnt/data/speedmetal/apps/rails2/redmine-1.1.1
    RAILS_ENV=production jruby -S rake db:migrate
    RAILS_ENV=production REDMINE_LANG=en jruby -S rake redmine:load_default_data

Create a deployment descriptor

    rm -f $JBOSS_HOME/server/default/deploy/*-knob.yml
    cat << EOF > $JBOSS_HOME/server/default/deploy/redmine-knob.yml
    ---
    application:
      root: /mnt/data/speedmetal/apps/rails2/redmine-1.1.1/
      env: production
    web:
      context: /
    EOF

Start TorqueBox

    screen
    $JBOSS_HOME/bin/run.sh -b 0.0.0.0



# Trinidad Setup

Install prerequisite gems

    jruby -S gem install -v=0.4.2 i18n
    jruby -S gem install -v=1.0.1 rack
    jruby -S gem install -v=0.9.7 activerecord-jdbcmysql-adapter

Migrate database and load default data

    cd /mnt/data/speedmetal/apps/rails2/redmine-1.1.1
    RAILS_ENV=production jruby -S rake db:migrate
    RAILS_ENV=production REDMINE_LANG=en jruby -S rake redmine:load_default_data

Start Trinidad

    screen
    JAVA_OPTS="-Xmx2048m" jruby -S trinidad -p 8080 -e production -t



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

Start GlassFish

    JAVA_OPTS="-Xmx2048m" jruby -S glassfish -p 8080 -e production



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
    passenger start -p 8080 -e production --max-pool-size 10



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
    worker_processes 10
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

Then verify you can ssh into the server without a password

    ssh server

Finally, kick off the benchmark

    screen
    tsung -f /home/ec2-user/speedmetal/apps/rails2/redmine-1.1.1/tsung.xml start
