#!/bin/bash
# @autor ricardo.carrillo
# @wed dic 23 14:00:49 CST 2015
# @goal Determina las IP's y MAC's de cada host por red
sh determina-vivas.sh > .vivas
for i in $(sudo virsh net-list  --all  | awk '{print $1}'  | egrep -ve "^(N|-|$)") ; do  
	NETDEV=$(sudo virsh net-info $i|grep "^Pu"|awk '{print $2}')
	NETWORK=$(ifconfig $NETDEV 2>/dev/null | egrep -B0 "inet " |awk '{print $2}')
	SEGMENT=$(echo $NETWORK|cut -d"." -f1,2,3)
	if [[ "$NETWORK" != ""  ]] ; then
		echo "$i:$NETDEV:$NETWORK hay:"
		grep "^$SEGMENT" .vivas |sed -e "s/^[0-9]\{3\}/\t->&/g"
	fi
done
