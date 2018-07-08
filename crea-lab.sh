#! /bin/sh
###################################################################
## INITAL VARIABLES TO SET ENVIRONMENT LABORATORY
## Autor: Ricardo David Carrillo Sanchez	<dominus.ceo@gmail.com>
##						<dominus.ceo@openinsecureit.mx>
## Objetivo: Creacion de maquinas virtuales para laboratorios de redhat.
## Created sáb jun  4 12:51:02 CDT 2011
source ./.datalab
source ./init-functions
# MAIN PROGRAM
[[ "$(verify_user)" == "" ]];  doHelp || continue
if  [[ -n "$1" && -n "$2" ]] ; then
	network=$(getNetworkName $1)
	distro=$(getDistro $2)
	if [ -f .foundation ] ; then 
		val=$(cat .foundation)
		mkdir -pv $sdirectory
		if [[ "$val" -lt 254  ]] ; then
			val=$((val+1)) ; echo $val > .foundation ; val=$(cat .foundation)
			nsnapshot=$foundation${val}
			echo sh crea-nodo.sh $nsnapshot $network $distro
			echo qemu-img create -b ${sdirectory}rh124-$distro-template.img -f qcow2 ${sdirectory}${nsnapshot}/rh124-desktop-snap.ovl
			echo qemu-img create -b ${sdirectory}rh124-$distro-template.img -f qcow2 ${sdirectory}${nsnapshot}/rh124-server-snap.ovl
        		echo virt-install --connect qemu:///system -n desktop${var} -r $MEM --os-type=linux --os-variant=$OSVARIANT --disk path=${sdirectory}${nsnapshot}/rh124-desktop-snap.ovl,device=disk,format=qcow2 -w network=$network,model=virtio --vcpus=1 --vnc --noautoconsole --import
		        echo virt-install --connect qemu:///system -n server${var} -r $MEM --os-type=linux --os-variant=$OSVARIANT --disk path=${sdirectory}${nsnapshot}/rh124-server-snap.ovl,device=disk,format=qcow2 -w network=$network,model=virtio --vcpus=1 --vnc --noautoconsole --import
		else
			echo "It is not possible create more than 254 foundation hosts"
		fi
	else
		echo "No configfile available"
	fi
fi

