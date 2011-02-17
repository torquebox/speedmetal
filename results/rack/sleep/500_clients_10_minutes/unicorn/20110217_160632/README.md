Using 500 unicorn workers

Memory usage during the benchmark:
    $ free -m
                 total       used       free     shared    buffers     cached
    Mem:          7469       7101        368          0        200       2065
    -/+ buffers/cache:       4835       2634
    Swap:            0          0          0

Memory usage after the benchmark:
    $ free -m
                 total       used       free     shared    buffers     cached
    Mem:          7469       2626       4842          0        200       2065
    -/+ buffers/cache:        360       7108
    Swap:            0          0          0
