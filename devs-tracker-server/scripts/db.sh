#!/bin/bash

sudo apt update
# Install software
sudo apt install -y postgresql postgresql-contrib net-tools
# Move data to volume
sudo service postgresql stop
mkdir -p /mnt/$(ls /mnt)/postgresql/12
mv /var/lib/postgresql/12/main /mnt/$(ls /mnt)/postgresql/12/main
ln -s /mnt/$(ls /mnt)/postgresql/12/main /var/lib/postgresql/12/main
# Config
cp /etc/postgresql/12/main/postgresql.conf /etc/postgresql/12/main/postgresql.conf.backup
sed -i "s/^#listen_addresses.*$/listen_addresses = '$(ifconfig eth1 | grep netmask | awk '{print $2}')'/" /etc/postgresql/12/main/postgresql.conf
sudo service postgresql start
# Create user
sudo -u postgres createuser devstracker
sudo -u postgres createdb devstracker
sudo useradd -s /usr/sbin/nologin -p $(openssl passwd -1 devstracker) devstracker
echo Finished