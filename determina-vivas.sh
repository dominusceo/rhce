# Script para determinar las direcciones IP vivas
EXISTE=$(rpm -qa nmap)
if [ ! -z $EXISTE ] ; then
	for i in $(ifconfig | grep -i virb  | awk '{print $1}' | tr -d ":" ) ; do 
		IPADDR=$(ifconfig | egrep -A1 $i| grep inet|awk '{print $2}')
		SEG=$(echo $IPADDR|cut -d"." -f1,2,3)
		sudo nmap -n  -sP  $SEG.2-254 | egrep -B1 "Nmap scan report for|MAC Address" | awk '/Nmap scan report/{printf $5;printf " ";getline;getline;print $3;}'
		RETVAL=$?
	done
else
	echo "no existe paquete nmap"
	dnf install -y nmap
fi
