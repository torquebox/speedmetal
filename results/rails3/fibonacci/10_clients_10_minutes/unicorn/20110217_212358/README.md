[root@domU-12-31-39-0E-42-62 fibonacci]# cat /tmp/unicorn.rb 
worker_processes 10
preload_app true
timeout 30
listen 8080, :backlog => 2048


memory during test
[root@domU-12-31-39-0E-42-62 hello_world]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3361       4108          0        202       2103
-/+ buffers/cache:       1054       6414
Swap:            0          0          0

memory after test
[root@domU-12-31-39-0E-42-62 hello_world]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3003       4465          0        203       2114
-/+ buffers/cache:        686       6782
Swap:            0          0          0
