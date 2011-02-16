# Running Benchmarks

## Launch EC2 Instance
Launch 2 instances of ami-e291668b in the same availability zone

## Configure Client Instance
    yum install make erlang R mercurial git wget
    wget http://cran.r-project.org/src/contrib/getopt_1.15.tar.gz
    tar xzf getopt_1.15.tar.gz
    R CMD INSTALL getopt
    git clone git://github.com/basho/basho_bench.git
    cd basho_bench
    make

## Configure Server Instance

### Install Prerequisites
    yum install java-1.6.0-openjdk wget unzip git make gcc gcc-c++ \
      ruby ruby-devel rubygems curl-devel openssl-devel zlib-devel

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

### Install Passenger
    gem install passenger

### Install Thin
    gem install thin

### Install Trinidad
    jruby -S gem install trinidad