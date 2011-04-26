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
`maxThreads="500"` to the port 8080 HTTP connector element.

# Start TorqueBox

    screen
    $JBOSS_HOME/bin/run.sh -b 0.0.0.0

# Run Benchmark

From Tsung machine, test app is running via curl

    curl http://server:8080/

Then verify you can ssh into the server and localhost without a
password

    ssh server
    ssh localhost

Finally, kick off the benchmark

    screen
    tsung -f /home/ec2-user/speedmetal/apps/rails3/beer_tweets/tsung.xml start
