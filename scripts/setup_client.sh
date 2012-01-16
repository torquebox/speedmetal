#!/bin/bash

# exit if an error occurs in any simple command
set -e
# exit if an error occurs in a pipeline
set -o pipefail

usage() {
    echo "Usage: `basename $0` server_instance_ip_address"
    echo "       server_instance_ip_address is the IP address of the server instance"
    exit 1
}

[[ $# -ne 1 ]] && usage

SERVER_IP=$1

cd ~

# Install necessary RPMs
sudo yum install -y erlang wget make git perl-Template-Toolkit gnuplot screen

# Clone SpeedMetal
git clone git://github.com/torquebox/speedmetal.git

# Install Tsung
wget http://tsung.erlang-projects.org/dist/tsung-1.3.3.tar.gz
tar xf tsung-1.3.3.tar.gz
cd tsung-1.3.3
./configure
make
sudo make install
cd ../

# Add /etc/hosts entry for our server instance
echo "$SERVER_IP server" | sudo tee -a /etc/hosts

# Open up iptables
sudo iptables -I INPUT -p tcp -j ACCEPT
sudo iptables -I INPUT -p udp -j ACCEPT

echo ""
echo "Client Setup Finished Successfully"
echo ""
