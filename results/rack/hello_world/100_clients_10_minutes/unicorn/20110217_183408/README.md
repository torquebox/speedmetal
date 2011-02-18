20 workers - tested at 100 workers but didn't impact req/s

during test
[root@domU-12-31-39-0E-42-62 hello_world]# free -m
             total       used       free     shared    buffers     cached
Mem:          7469       3146       4322          0        201       2065
-/+ buffers/cache:        878       6590
Swap:            0          0          0

after test

forgot to take free -m snapshot after test but should be similar to
others after test, with 4.5GB free
