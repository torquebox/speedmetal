passenger start -p 8080 -e production --max-pool-size 50

tested with max pool size of 10 and 100 and 50 gave highest req/s

during testing

[root@domU-12-31-39-0E-42-62 hello_world]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3440       4028          0        202       2065
-/+ buffers/cache:       1173       6296
Swap:            0          0          0

after testing

[root@domU-12-31-39-0E-42-62 hello_world]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2978       4490          0        202       2065
-/+ buffers/cache:        711       6758
Swap:            0          0          0
