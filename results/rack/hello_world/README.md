# Running the benchmark
    cat << EOF > hello.config
    {mode, max}.
    {duration, 10}.
    {concurrent, 10}.
    {driver, basho_bench_driver_http_raw}.
    {code_paths, ["deps/stats",
                  "deps/ibrowse"]}.
    {key_generator, {int_to_str, {uniform_int, 5000000}}}.
    {value_generator, {fixed_bin, 10000}}.
    {operations, [{get, 1}]}.
    {http_raw_ips, ["10.192.65.140"]}.
    {http_raw_port, 8080}.
    {http_raw_path, "/hello"}.
    EOF

    ./basho_bench hello.config

    /usr/bin/Rscript --vanilla priv/summary.r -i tests/current

Replace the `http_raw_ips` value with the IP of your server
instance. Run the benchmark once for every server you want to test,
ensuring that only one server is running on the server instance at a
time.


# TorqueBox Setup

## Create TorqueBox deployment descriptor
    cat << EOF > $JBOSS_HOME/server/default/deploy/hello-knob.yml  
    ---  
    application:  
      root: /home/ec2-user/speedmetal/apps/rack/hello_world/  
      env: production  
    web:  
      context: /hello  
    EOF

## Start TorqueBox
    $JBOSS_HOME/bin/run.sh -b 0.0.0.0


# Passenger Setup

## Copy app to /tmp
Passenger needs the nginx workers that run as the 'nobody' user
to have access to the application.
    rm -rf /tmp/hello_world
    cp -r speedmetal/apps/rack/hello_world/ /tmp/

## Make public directory
Passenger expects all apps to have a public/ directory
    cd /tmp/hello_world
    mkdir public

## Start Passenger
    passenger start -p 8080 -e production


# Thin Setup

## Start Thin
    cd speedmetal/apps/rack/hello_world/  
    thin -p 8080 -e production start


# Trinidad Setup

## Start Trinidad
    cd speedmetal/apps/rack/hello_world/  
    jruby -S trinidad -r -p 8080 -e production -t
