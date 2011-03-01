# TorqueBox Setup

Install prerequisite gems

    jruby -S gem install -v=0.4.2 i18n
    jruby -S gem install -v=1.0.1 rack
    jruby -S gem install -v=0.9.7 activerecord-jdbcmysql-adapter

Migrate database and load default data

    cd speedmetal/apps/rails2/redmine-1.1.1
    RAILS_ENV=production jruby -S rake db:migrate
    RAILS_ENV=production jruby -S rake redmine:load_default_data

When prompted for a language select the default of en.

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

    $JBOSS_HOME/bin/run.sh -b 0.0.0.0


# Passenger Setup

Install prerequisite gems

    sudo gem install -v=0.4.2 i18n
    sudo gem install -v=1.0.1 rack
    sudo yum install mysql-libs mysql-devel
    sudo gem install mysql

Migrate database and load default data

    cd speedmetal/apps/rails2/redmine-1.1.1
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production rake redmine:load_default_data

Start Passenger

    passenger start -p 8080 -e production



# Run Benchmark

From Tsung machine, test app is running via curl

    curl http://server:8080/

Then verify you can ssh into the server without a password

    ssh server

Finally, kick off the benchmark

    tsung -f speedmetal/apps/rails2/redmine-1.1.1/tsung.xml start
