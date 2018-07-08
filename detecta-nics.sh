#!/bin/bash
tarjetas=$(ip a s| awk -F": " '{print $2}'| sed -e "/^$/d"| egrep -v -e "nic|lo")
for i in $(echo $tarjetas) ; do
	ip=$(ifconfig $i |  grep -i "inet "| awk '{print $2}')
	est=$(ethtool $i| grep "Link detected"| awk -F": " '{print $2}')
	echo $i:$ip:$est
done
