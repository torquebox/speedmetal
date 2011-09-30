# Common Setup

Install ImageMagick

    sudo yum install ImageMagick

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

Edit $JBOSS_HOME/standalone/configuration/standalone.xml and change
"<inet-address value='127.0.0.1'/>" to "<any-ipv4-address/>" for the
public interface.

Edit $JBOSS_HOME/standalone/configuration/standalone.xml and add a
property to control the maximum number of HTTP threads:

    </extensions>
    <system-properties>
        <property name='org.torquebox.web.http.maxThreads' value='100'/>
    </system-properties>
    <management>

Start TorqueBox

    screen
    $JBOSS_HOME/bin/standalone.sh -Djboss.bind.address=0.0.0.0 -Dorg.torquebox.web.http.maxThreads=100



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
