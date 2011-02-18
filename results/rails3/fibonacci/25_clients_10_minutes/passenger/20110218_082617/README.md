pool size of 10

memory usage during test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2621       4847          0        213       1663
-/+ buffers/cache:        744       6724
Swap:            0          0          0

memory usage after test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2234       5234          0        213       1663
-/+ buffers/cache:        357       7111
Swap:            0          0          0

load during test
 08:33:34 up 1 day, 18:49,  2 users,  load average: 11.27, 9.51, 9.02
