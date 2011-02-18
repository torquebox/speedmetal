unicorn setup w/ 10 workers

memory usage during test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3730       3738          0        212       2454
-/+ buffers/cache:       1063       6405
Swap:            0          0          0

memory usage after test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3388       4080          0        212       2465
-/+ buffers/cache:        710       6758
Swap:            0          0          0

load during test
 08:19:27 up 1 day, 18:35,  2 users,  load average: 10.05, 9.90, 10.60
