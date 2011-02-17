# Running Benchmarks

## Launch EC2 Instance
Launch 2 instances of ami-e291668b in the same availability
zone with size m1.large.

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
