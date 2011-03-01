# TorqueBox Setup

Install prerequisite gems

    jruby -S gem install -v=0.4.2 i18n
    jruby -S gem install -v=1.0.1 rack
    jruby -S gem install -v=0.9.7 activerecord-jdbcmysql-adapter

Replace host in config/database.yml with Amazon RDS endpoint.

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


# Run Benchmark

    tsung -f speedmetal/apps/rails2/redmine-1.1.1/tsung.xml start
