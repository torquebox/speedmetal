# Create TorqueBox deployment descriptor
    cat << EOF > $JBOSS_HOME/server/default/deploy/hello-knob.yml  
    ---  
    application:  
      root: /home/ec2-user/speedmetal/apps/rack/hello_world/  
      env: production  
    web:  
      context: /hello  
    EOF
# Start TorqueBox
    $JBOSS_HOME/bin/run.sh -b 0.0.0.0
