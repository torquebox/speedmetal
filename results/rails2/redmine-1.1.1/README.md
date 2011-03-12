All tests use a m1.large tsung instance and a c1.xlarge server
instance.

A copy of the specific tsung.xml used for each test is in its
directory.


Other test notes:

passenger_ree/20110308-16:23
* max-pool-size 18
* kept getting 502 errors but plenty of CPU to spare

passenger_ree/20110308-16:53
* max-pool-size 30
* otherwise same as 20110308-16:23
* didn't increase throughput w/ more workers, actually
  lowered it some



After about 53 minutes into the tests below I accidentally killed all
iTerm windows. I was using screen on each server but when reattaching
to my screen sessions SSH agent forwarding didn't work any
longer. This is why Glassfish and Unicorn tests exited - they were
backing up clients quickly which meant spawning new tsung beam
processes to handle the increase # of simultaneous clients and this
stopped working after SSH agent forwarding broke.

So, only compare data before the 53 minute mark for GlassFish and
Unicorn's 20110308-19:44 tests.

It also looks like the RDS CPU usage was at or near 100% for all
servers except GlassFish.

torquebox/20110308-19:44
* maxThreads set to 100
* Xms and Xmx set to 2048m

trinidad/20110308-19:44
* maxThreads set to 100
* Xmx set to 2048m
* ran out of open file handles after about 30 minutes

glassfish/20110308-19:44
* max-thread-pool-size set to 100
* Xmx set to 2048m
* above Xmx did not take effect, was actually 500m

passenger_ree/20110308-19:44
* max-pool-size 18

unicorn_ree/20110308-19:44
* worker_processes 18
* timeout 30
* backlog 2048



trinidad/20110308-22:01
* same test as 20110308-19:44 but w/o killing iTerm window
* maxThreads set to 100
* Xmx set to 2048m
* ulimit -n 4096
* still ran out of open file handles after about 30 minutes
  but didn't seem to lower throughput
* terminated after 73 minutes because of so many open file errors

    Mar 8, 2011 6:13:40 PM org.apache.tomcat.util.net.JIoEndpoint$Acceptor run
    SEVERE: Socket accept failed
    java.net.SocketException: Too many open files
            at java.net.PlainSocketImpl.socketAccept(Native Method)
            at java.net.AbstractPlainSocketImpl.accept(AbstractPlainSocketImpl.java:375)
            at java.net.ServerSocket.implAccept(ServerSocket.java:470)
            at java.net.ServerSocket.accept(ServerSocket.java:438)
            at org.apache.tomcat.util.net.DefaultServerSocketFactory.acceptSocket(DefaultServerSocketFactory.java:59)
            at org.apache.tomcat.util.net.JIoEndpoint$Acceptor.run(JIoEndpoint.java:205)
            at java.lang.Thread.run(Thread.java:636)


unicorn_ree/20110308-22:01
* same test as 20110308-19:44 but w/o killing iTerm window
* worker_processes 18
* timeout 30
* backlog 2048

passenger/20110309-13:19
* max-pool-size 18

unicorn/20110309-13:19
* worker_processes 18
* timeout 30
* backlog 2048
* clients backed up significantly but test finished

thin/20110309-13:19
* clients backed up so much that tsung client ran out of sockets after
  about 65 minutes

torquebox/20110311-14:23
* maxThreads set to 100
* Xmx2048m

passenger_ree/20110311-15:17
* max-pool-size 18

unicorn_ree/20110311-16:43
* worker_processes 18
* timeout 30
* backlog 2048
* once over ~8500 tsung users got "exec request failed on channel 0"

trinidad/20110311-19:30
* Xmx set to 2048m
* apparently all previous tests weren't actually setting Xmx to 2048m
* maxThreads set to 100
* once over ~4500 tsung users got "Write failed: Broken pipe"

glassfish/20110312-14:13
* Xmx set to 2048m
* max-thread-pool-size set to 100

passenger/20110312-14:13
* max-pool-size 18

unicorn/20110312-14:13
* worker_processes 18
* timeout 30
* backlog 2048
