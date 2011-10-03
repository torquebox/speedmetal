# Setup

These instructions are for running a benchmark against a single
server. You'll need to repeat the instructions for each server you
want to benchmark, substituting in the specific server installation
instructions from the next section.


## Launch RDS Instance

Engine: mysql  
DB Instance Class: db.m1.large  
DB Engine Version: 5.1.57 (default)
Auto Minor Version Upgrade: Yes  
Multi-AZ Deployment: No  

Allocated Storage: 5 GB  
DB Instance Identifier: whatever  
Master User Name: benchmarks  
Master User Password: benchmarks  

Database Name: benchmark  
Database Port: 3306  
Availability Zone: same as other instances  
DB Parameter Group: default  
DB Security Group: benchmarks (new one created that only gives access  
                   from machines in benchmarks EC2 security group)

Backup Retention Period: 0 days  
Maintenance Window: No Preference


## Launch Tsung Instance

Launch instance of `ami-e291668b` with size m1.large. When SSHing into
the instance, make sure to use Agent Forwarding so we can SSH from the
Tsung instance to other instances without a password. For this to work
on my Mac, I had to

    ssh-add ~/.ssh/my_ec2_key.pem

Login to the instance then run the setup_client.sh script.

    curl -o setup_client.sh https://raw.github.com/torquebox/speedmetal/master/scripts/setup_client.sh
    chmod +x setup_client.sh
    ./setup_client.sh server_instance_ip_address


## Launch Server Instance

Launch instance of 'ami-e291668b' with size c1.xlarge in the same
availability zone and security group as the Tsung instance.

Login to the instance then run the setup_server.sh script.

    curl -o setup_server.sh https://raw.github.com/torquebox/speedmetal/master/scripts/setup_server.sh
    chmod +x setup_server.sh
    ./setup_server.sh server_type rds_instance_ip_address
