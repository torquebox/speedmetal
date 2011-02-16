# Create TorqueBox deployment descriptor
    cat << EOF > $JBOSS_HOME/server/default/deploy/hello-knob.yml
    ---
    application:
      root: /home/ec2-user/speedmetal/apps/rails3/hello_world/
      env: production
    web:
      context: /
    EOF
# Install needed gems
    jruby -S gem install bundler
    cd speedmetal/apps/rails3/hello_world/
    jruby -S bundle install
# Start TorqueBox
    $JBOSS_HOME/bin/run.sh -b 0.0.0.0
