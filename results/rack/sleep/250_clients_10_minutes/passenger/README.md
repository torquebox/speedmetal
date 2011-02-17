Passenger was only started with 200 workers instead of 250 - I was
hitting getting an error during benchmarking (pasted below) with 250
workers even though ulimit -n (open files) was 4096 and ulimit -u (max
processes) was 1024.

Also of note is that running 200 concurrent Ruby processes used a
substantial amount of RAM. The exact number wasn't recorded but it was
about 1.3GB higher than the amount TorqueBox used on the same test.

[ pid=31681 thr=70136304509360 file=utils.rb:176 time=2011-02-17 12:42:52.877 ]: *** Exception Errno::EAGAIN in application (Resource temporarily unavailable - fork(2)) (process 31681, thread #<Thread:0x7f93c3084360>):
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/utils.rb:476:in `fork'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/utils.rb:476:in `safe_fork'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/rack/application_spawner.rb:165:in `handle_spawn_application'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/abstract_server.rb:357:in `__send__'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/abstract_server.rb:357:in `server_main_loop'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/abstract_server.rb:206:in `start_synchronously'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/abstract_server.rb:180:in `start'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/rack/application_spawner.rb:128:in `start'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/spawn_manager.rb:253:in `spawn_rack_application'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/abstract_server_collection.rb:132:in `lookup_or_add'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/spawn_manager.rb:246:in `spawn_rack_application'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/abstract_server_collection.rb:82:in `synchronize'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/abstract_server_collection.rb:79:in `synchronize'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/spawn_manager.rb:244:in `spawn_rack_application'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/spawn_manager.rb:137:in `spawn_application'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/spawn_manager.rb:275:in `handle_spawn_application'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/abstract_server.rb:357:in `__send__'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/abstract_server.rb:357:in `server_main_loop'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/lib/phusion_passenger/abstract_server.rb:206:in `start_synchronously'
        from /var/lib/passenger-standalone/3.0.2-x86_64-ruby1.8.7-linux-gcc4.5.1-1002/support/helper-scripts/passenger-spawn-server:99
