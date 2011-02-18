memory usage during test
[root@domU-12-31-39-0E-42-62 ec2-user]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3717       3751          0        212       2415
-/+ buffers/cache:       1089       6379
Swap:            0          0          0

memory usage after test
[root@domU-12-31-39-0E-42-62 ec2-user]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3323       4146          0        212       2416
-/+ buffers/cache:        694       6774
Swap:            0          0          0

load during test
 08:07:51 up 1 day, 18:23,  2 users,  load average: 19.96, 18.51, 13.72
