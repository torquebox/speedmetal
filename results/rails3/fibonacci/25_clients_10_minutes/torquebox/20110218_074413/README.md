memory usage during test
[root@domU-12-31-39-0E-42-62 ec2-user]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3964       3505          0        210       2324
-/+ buffers/cache:       1428       6040
Swap:            0          0          0

memory usage after test
[root@domU-12-31-39-0E-42-62 ec2-user]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3228       4240          0        211       2325
-/+ buffers/cache:        692       6776
Swap:            0          0          0

load during test
 07:53:38 up 1 day, 18:09,  2 users,  load average: 21.48, 17.86, 9.42
