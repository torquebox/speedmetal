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
