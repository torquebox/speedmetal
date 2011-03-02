#!/bin/bash

# exit if an error occurs in any simple command
set -e
# exit if an error occurs in a pipeline
set -o pipefail

usage() {
    echo "Usage: `basename $0` server_type rds_instance_ip_address"
    echo "       server_type is one of torquebox, trinidad, glassfish, unicorn,"
    echo "                             passenger, or thin"
    echo "       rds_instance_ip_address is the IP address of the Amazon RDS instance"
    exit 1
}

[[ $# -ne 2 ]] && usage

SERVER_TYPE=$1
RDS_IP=$2

# Create writable directory under /mnt because the root
# partition isn't large on EC2 instances
sudo mkdir /mnt/data
sudo chmod 777 /mnt/data
cd /mnt/data

# Install necessary RPMs
sudo yum install -y erlang git

# Clone SpeedMetal
git clone git://github.com/torquebox/speedmetal.git

# Add /etc/hosts entry for our RDS instance
echo "$RDS_IP database" | sudo tee -a /etc/hosts

case "$SERVER_TYPE" in
    torquebox)
        # Install necessary RPMs
        sudo yum install -y java-1.6.0-openjdk wget unzip
        # Install latest TorqueBox dev build
        wget http://torquebox.org/torquebox-dev.zip
        unzip torquebox-dev.zip
        ln -s torquebox-1.0.0.CR1-SNAPSHOT/ torquebox-current
        echo "export TORQUEBOX_HOME=/mnt/data/torquebox-current" >> ~/.bash_profile
        echo "export JBOSS_HOME=\$TORQUEBOX_HOME/jboss" >> ~/.bash_profile
        echo "export JRUBY_HOME=\$TORQUEBOX_HOME/jruby" >> ~/.bash_profile
        echo "export PATH=\$JRUBY_HOME/bin:\$PATH" >> ~/.bash_profile
        source ~/.bash_profile
        jruby -S gem install jruby-openssl
        # Increase default heap size
        sed -i 's/512m/1024m/' $JBOSS_HOME/bin/run.conf
        # Increase open file limit
        echo "ec2-user hard nofile 4096" | sudo tee -a /etc/security/limits.conf
        echo "ec2-user shoft nofile 4096" | sudo tee -a /etc/security/limits.conf
        echo "ulimit -n 4096" >> ~/.bash_profile
        echo "Please log out and back in to finish the installation"
        ;;
    trinidad)
        # Install necessary RPMs
        sudo yum install -y java-1.6.0-openjdk wget
        # Install JRuby
        wget http://jruby.org.s3.amazonaws.com/downloads/1.5.6/jruby-bin-1.5.6.tar.gz
        tar xf jruby-bin-1.5.6.tar.gz
        echo "export JRUBY_HOME=/mnt/data/jruby-1.5.6" >> ~/.bash_profile
        echo "export PATH=\$JRUBY_HOME/bin:\$PATH" >> ~/.bash_profile
        source ~/.bash_profile
        jruby -S gem install jruby-openssl
        # Install Trinidad
        jruby -S gem install trinidad
        echo "Please log out and back in to finish the installation"
        ;;
    glassfish)
        # Install necessary RPMs
        sudo yum install -y java-1.6.0-openjdk wget
        # Install JRuby
        wget http://jruby.org.s3.amazonaws.com/downloads/1.5.6/jruby-bin-1.5.6.tar.gz
        tar xf jruby-bin-1.5.6.tar.gz
        echo "export JRUBY_HOME=/mnt/data/jruby-1.5.6" >> ~/.bash_profile
        echo "export PATH=\$JRUBY_HOME/bin:\$PATH" >> ~/.bash_profile
        source ~/.bash_profile
        jruby -S gem install jruby-openssl
        # Install GlassFish
        jruby -S gem install glassfish
        echo "Please log out and back in to finish the installation"
        ;;
    passenger)
        # Install necessary RPMs
        sudo yum install -y ruby ruby-devel rubygems make gcc gcc-c++ \
            curl-devel openssl-devel zlib-devel
        # Install passenger
        sudo gem install passenger
        ;;
    unicorn)
        # Install necessary RPMs
        sudo yum install -y ruby ruby-devel rubygems make gcc gcc-c++ \
            curl-devel openssl-devel zlib-devel
        # Install unicorn
        sudo gem install unicorn
        ;;
    thin)
        # Install necessary RPMs
        sudo yum install -y ruby ruby-devel rubygems make gcc gcc-c++ \
            curl-devel openssl-devel zlib-devel
        # Install thin
        sudo gem install thin
        ;;
esac

echo ""
echo "$SERVER_TYPE Server Setup Finished Successfully"
echo ""
