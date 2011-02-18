memory usage during test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2303       5165          0        214       1685
-/+ buffers/cache:        404       7065
Swap:            0          0          0

memory usage after test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2263       5205          0        214       1691
-/+ buffers/cache:        357       7111
Swap:            0          0          0

load during test
 08:53:19 up 1 day, 19:09,  2 users,  load average: 0.99, 1.13, 3.51
