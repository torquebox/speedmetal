memory usage during test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3110       4358          0        215       1772
-/+ buffers/cache:       1122       6346
Swap:            0          0          0

memory usage after test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2339       5129          0        215       1766
-/+ buffers/cache:        358       7111
Swap:            0          0          0

load average during test
 09:14:29 up 1 day, 19:30,  2 users,  load average: 40.69, 30.27, 15.76
