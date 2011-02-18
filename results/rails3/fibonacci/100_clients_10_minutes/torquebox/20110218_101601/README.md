memory usage during test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3319       4149          0        218       1951
-/+ buffers/cache:       1149       6319
Swap:            0          0          0

memory usage after test
[root@domU-12-31-39-0E-42-62 fibonacci]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       2537       4931          0        218       1959
-/+ buffers/cache:        359       7109
Swap:            0          0          0

load during test
 10:24:52 up 1 day, 20:40,  2 users,  load average: 61.02, 42.88, 23.45
