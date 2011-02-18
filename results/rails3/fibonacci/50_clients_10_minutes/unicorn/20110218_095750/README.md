unicorn w/ 10 workers

memory during test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2822       4647          0        216       1881
-/+ buffers/cache:        723       6745
Swap:            0          0          0

memory after test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2472       4997          0        217       1896
-/+ buffers/cache:        358       7111
Swap:            0          0          0

load during test
 10:04:55 up 1 day, 20:20,  2 users,  load average: 10.00, 7.53, 6.05
