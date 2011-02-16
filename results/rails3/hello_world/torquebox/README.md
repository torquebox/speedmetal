# Create TorqueBox deployment descriptor
    cat << EOF > $JBOSS_HOME/server/default/deploy/hello-knob.yml
    ---
    application:
      root: /home/ec2-user/speedmetal/apps/rails3/hello_world/
      env: production
    EOF
# Start TorqueBox
    $JBOSS_HOME/bin/run.sh -b 0.0.0.0
