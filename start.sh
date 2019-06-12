#!/bin/bash
# This file initiates the wazigate preparation


# Please add the follwing command at the end of /etc/rc.local file right before exit 0;
#
# cd /home/pi/wazigate/; sudo bash ./start.sh &


# Uncomment these to have the logs
# exec 1>./wazigate-start.log 2>&1		# send stdout and stderr to a log file
# set -x                         		# tell sh to display commands before execution


#check if the server is accessible
acc=$(curl -Is https://waziup.io | head -n 1 | awk '{print $2}')
if [ "$acc" != "200" ]; then
	echo "Waziup.io is not accessible!"
fi

sudo iptables-restore < /etc/iptables.ipv4.nat

sudo systemctl stop hostapd
sudo systemctl start hostapd

sleep 2

#Starting the docker containers
cd /home/pi/wazigate/;  sudo docker-compose up &

sleep 10

sudo /etc/init.d/network-manager restart

sleep 2

#Check if the gateway is registered in remote.it and register it if needed
cd /home/pi/wazigate/remote.it/; sudo bash ./setup.sh

#Lunch the wazigate-host service
cd /home/pi/wazigate/wazigate-host/; sudo bash ./start.sh &

exit 0;
