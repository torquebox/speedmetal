memory usage during test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2832       4636          0        216       1847
-/+ buffers/cache:        769       6700
Swap:            0          0          0

memory usage after test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2422       5046          0        216       1848
-/+ buffers/cache:        358       7111
Swap:            0          0          0

load during test
 09:31:12 up 1 day, 19:47,  2 users,  load average: 32.22, 29.98, 21.75
