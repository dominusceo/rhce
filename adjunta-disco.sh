#! /bin/bash -x
mv=$1
executer=$(id -u)
source ./init-functions
if [ "$executer" == "0" ] ; then
	while [[ -z $mv ]] ; do
		getLiveNodes
		echo -n "Elija la maquina virtual a adjuntar el disco:"
		read mv
		if [ -n $mv ] ; then
			if [ -f ./.datalab ] ; then 
				source ./.datalab
				mv=$(getNode $mv )
				if [ "$mv" != "" ] ; then
					ruta="${vdirectory}$mv"
					diskLetter=$(tr -cd '[:lower:]' < /dev/urandom | fold -w1 | head -n1)
					disco="$mv-san-$diskLetter.img"
					xml="${vdirectory}$mv/$mv-$diskLetter.xml"
					mkdir -pv $ruta && qemu-img create -f raw ${ruta}/$disco 1G
					echo "<disk type='block' device='disk'>" > $xml
					echo "<driver name='qemu' type='raw' cache='none'/>">> $xml
					echo "<source dev='${ruta}/$disco'/>">> $xml
      					echo "<target dev='vdc' bus='virtio'/>">> $xml
					echo "</disk>">> $xml
					virsh attach-disk ${mv}"."$(getDomainMachine $mv) ${ruta}/$disco vd$diskLetter && echo "Disco  vd$diskLetter adjuntado"
				else
					unset $mv
				fi
			else
				echo "Falta archivo de configuracion (.datalab)"
			fi
		else
			continue
		fi
	done
else
	doHelp
fi
