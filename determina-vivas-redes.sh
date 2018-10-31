# Script para determinar las direcciones IP vivas
# @ricardo.carrillo: se actualiza version para que se puedan escanear todas las redes disponibles en la maquina fisica.
for i in $( ifconfig | egrep -A3 -e  "virb|vmnet|enp8s0|eno1"| grep -B2 "inet"  | awk '{print $1" "$2" "$3}' | sed -e "s/flags=.*//g;s/netmask//g;/--/d;/inet6.*.prefixlen*/d" |awk '/: /{printf $1;printf " ";getline;print $2;}' | tr -s " " ":") ; do
	TARJETA=$(echo "$i"|cut -d":" -f1)
	RED=$(echo "$i" | cut -d":" -f2|cut -d"." -f1,2,3)
	echo "Para la red ${RED}.0 ($TARJETA) hay:"
	sudo nmap -n  -sP  $RED.2-254 | egrep -B1 "Nmap scan report for|MAC Address" | awk '/Nmap scan report/{printf $5;printf " ";getline;getline;print $3;}' > .vivas
	grep "^$RED" .vivas |sed -e "s/^[0-9]\{1,3\}/\t->&/g"
done
