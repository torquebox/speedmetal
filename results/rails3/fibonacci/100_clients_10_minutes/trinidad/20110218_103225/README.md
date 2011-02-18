memory usage during the test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3054       4414          0        219       2030
-/+ buffers/cache:        804       6664
Swap:            0          0          0

memory usage after the test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2615       4854          0        219       2034
-/+ buffers/cache:        361       7107
Swap:            0          0          0

load during the test
 10:42:23 up 1 day, 20:58,  2 users,  load average: 46.33, 40.42, 30.26
