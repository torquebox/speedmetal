# Setup

These instructions are for running a benchmark against a single
server. You'll need to repeat the instructions for each server you
want to benchmark, substituting in the specific server installation
instructions from the next section.

## Configure Tsung Instance

### Launch EC2 Instance

Launch instance of ami-e291668b with size m1.large. When SSHing into
the instance, make sure to use Agent Forwarding so we can SSH from the
Tsung instance to other instances without a password. For this to work
on my Mac, I had to

    ssh-add ~/.ssh/my_ec2_key.pem

### Install Necessary RPMs

    sudo yum install erlang wget make git perl-Template-Toolkit gnuplot

### Clone SpeedMetal
    git clone git://github.com/torquebox/speedmetal.git

### Install Tsung
    wget http://tsung.erlang-projects.org/dist/tsung-1.3.3.tar.gz
    tar xf tsung-1.3.3.tar.gz
    cd tsung-1.3.3
    ./configure
    make
    sudo make install
    cd ../


## Configure Server Instance

### Lanch EC2 Instance

Launch instance of ami-e291668b with size m1.large in the same
availability zone and security group as the Tsung instance.

### Create writable directory under /mnt so we don't run out of HDD space
    sudo mkdir /mnt/data
    sudo chmod 777 /mnt/data
    cd /mnt/data

### Install Necessary RPMs
    sudo yum install erlang git

### Clone SpeedMetal
    git clone git://github.com/torquebox/speedmetal.git

### Install Server

Please see the appropriate section below for the details of installing
each server's needed software.


## Launch RDS Instance

Engine: mysql  
DB Instance Class: db.m1.large  
DB Engine Version: default  
Auto Minor Version Upgrade: Yes  
Multi-AZ Deployment: No  

Allocated Storage: 5 GB  
DB Instance Identifier: whatever  
Master User Name: benchmarks  
Master User Password: benchmarks  

Database Name: benchmark  
Database Port: 3306  
Availability Zone: same as other instances  
DB Parameter Group: default  
DB Security Group: benchmarks (new one created that only gives access  
                   from machines in benchmarks EC2 security group)

Backup Retention Period: 0 days  
Maintenance Window: No Preference


## Configure /etc/host

Add a host entry for database pointing to the IP of your Amazon RDS
instance on the server instance:

    sudo su
    echo "10.xxx.xxx.xxx database" >> /etc/hosts
    exit

Add a host entry for server pointing to the IP of your server instance
on the Tsung instance:

    sudo su
    echo "10.xxx.xxx.xxx server" >> /etc/hosts
    exit



# Server Installations

## TorqueBox

### Install prerequisites
    sudo yum install java-1.6.0-openjdk wget unzip

### Install TorqueBox
    wget http://torquebox.org/torquebox-dev.zip
    unzip torquebox-dev.zip
    ln -s torquebox-1.0.0.CR1-SNAPSHOT/ torquebox-current
    echo "export TORQUEBOX_HOME=/mnt/data/torquebox-current" >> ~/.bash_profile
    echo "export JBOSS_HOME=\$TORQUEBOX_HOME/jboss" >> ~/.bash_profile
    echo "export JRUBY_HOME=\$TORQUEBOX_HOME/jruby" >> ~/.bash_profile
    echo "export PATH=\$JRUBY_HOME/bin:\$PATH" >> ~/.bash_profile
    source ~/.bash_profile
    change Xmx to 1024m in $JBOSS_HOME/bin/run.conf
    jruby -S gem install jruby-openssl

### Increase ulimit
    sudo su
    echo "ec2-user hard nofile 4096" >> /etc/security/limits.conf
    echo "ec2-user shoft nofile 4096" >> /etc/security/limits.conf
    exit

Log out and back in to pick up the new ulimit


## Passenger

### Install prerequisites
    sudo yum install ruby ruby-devel rubygems make gcc gcc-c++ \
    curl-devel openssl-devel zlib-devel

### Install Passenger
    sudo gem install passenger








# Old Instructions Below

# Running Benchmarks

## Launch EC2 Instance
Launch 2 instances of ami-e291668b in the same availability
zone with size m1.large.

## Configure Client Instance
    yum install make erlang R mercurial git wget
    wget http://cran.r-project.org/src/contrib/getopt_1.15.tar.gz
    tar xzf getopt_1.15.tar.gz
    R CMD INSTALL getopt
    git clone git://github.com/torquebox/basho_bench.git
    cd basho_bench
    make

## Configure Server Instance

### Install Prerequisites
    yum install java-1.6.0-openjdk wget unzip git make gcc gcc-c++ \
      ruby ruby-devel rubygems curl-devel openssl-devel zlib-devel

### Install Memcached
    yum install memcached

### Increase Open File Limit
TorqueBox recommends > 1024 open file limit and Passenger needs
this when running high numbers of workers.
    ulimit -n 4096

### Clone SpeedMetal
    git clone git://github.com/torquebox/speedmetal.git

### Install TorqueBox
    wget http://torquebox.org/torquebox-dev.zip
    unzip torquebox-dev.zip
    ln -s torquebox-1.0.0.CR1-SNAPSHOT/ torquebox-current
    export TORQUEBOX_HOME=/home/ec2-user/torquebox-current
    export JBOSS_HOME=$TORQUEBOX_HOME/jboss
    export JRUBY_HOME=$TORQUEBOX_HOME/jruby
    export PATH=$JRUBY_HOME/bin:$PATH
    change Xmx to 1024m in $JBOSS_HOME/bin/run.conf
    jruby -S gem install jruby-openssl

### Install Passenger
    gem install passenger

### Install Thin
    gem install thin

### Install Trinidad
    jruby -S gem install trinidad

### Install Unicorn
    gem install unicorn

## Other Notes

After each server is started a browser/wget/curl/whatever hits the app
to make sure it's up and then the benchmark is run. No warm-up is
given to the app so the first minute or two of each benchmark will
show how the server ramps up to load.


# Generating Graphs

## Throughput Comparison
    export RESULTS_DIR="results/rack/hello_world/10_clients_10_minutes"
    latest_result() { find $1 -type d -depth 1 | tail -n 1; }
    ./scripts/compare.r -o $RESULTS_DIR/comparison.png --dir1 `latest_result $RESULTS_DIR/torquebox/` --tag1 TorqueBox --dir2 `latest_result $RESULTS_DIR/trinidad/` --tag2 Trinidad --dir3 `latest_result $RESULTS_DIR/unicorn/` --tag3 Unicorn --dir4 `latest_result $RESULTS_DIR/passenger/` --tag4 Passenger --dir5 `latest_result $RESULTS_DIR/thin/` --tag5 Thin
