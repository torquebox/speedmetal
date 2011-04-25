# Check Out Beer Tweets

    cd /mnt/data/speedmetal/apps/rails3/beer_tweets
    git clone git://github.com/bbrowning/beer_tweets.git .

# Install Gems

    jruby -S gem install bundler
    jruby -S bundle install

# Migrate Database and Load Seed Data

    RAILS_ENV=production jruby -S rake db:migrate
    RAILS_ENV=production jruby -S rake db:seed

# Create Deployment Descriptor

    rm -f $TORQUEBOX_HOME/apps/*-knob.yml
    cat << EOF > $TORQUEBOX_HOME/apps/beer_tweets-knob.yml
    ---
    application:
      root: /mnt/data/speedmetal/apps/rails3/beer_tweets
      env: production
    web:
      context: /
    EOF

# Set Max Threads

Edit $JBOSS_HOME/server/default/deploy/jbossweb.sar/server.xml and add
`maxThreads="100"` to the port 8080 HTTP connector element.

# Start TorqueBox

    screen
    $JBOSS_HOME/bin/run.sh -b 0.0.0.0
