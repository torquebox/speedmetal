10 workers

memory usage during test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3153       4315          0        221       2197
-/+ buffers/cache:        734       6734
Swap:            0          0          0

memory usage after test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2814       4654          0        221       2226
-/+ buffers/cache:        366       7103
Swap:            0          0          0

load during the test
 11:36:17 up 1 day, 21:52,  2 users,  load average: 7.75, 5.82, 5.46
