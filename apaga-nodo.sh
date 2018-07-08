#! /bin/bash
mv=$1
source ./init-functions
executer=$(verify_user)
if [ "$executer" == "0" ] ; then
	if [ -f ./.datalab ] ; then
		source ./.datalab
		while [[ -z $mv && $mv -gt 1 && $mv != "T" || $mv != "t" ]] ; do
			listAllNodes
			echo -n "Elige el nombre de la maquina virtual para apagar o selecciona todas con 't' o 'T'):";read mv
			todas=$(echo $mv | tr "[:upper:]" "[:lower:]")
			machine=$(getMachineName $mv)
			nameMachine=$(validaNameMachine $mv)
			if [[ "$todas" == "t" ]] ; then
				for i in $(getNodes live); do
					domain=$(getDomainMachine $i)
					shutDownMachines $i $domain
				done
			elif [[ ! -z $mv && ! -z $machine ]] ; then
				nameMachine=$(validaNameMachine $mv)
				if [[ "$nameMachine" != "null" ]] ; then
					domain=$(getDomainMachine $mv)
					shutDownMachines $mv $domain
				else
					machine=$(getNameMachineId $mv)
					idmach=${machine[0]}
					namema=${machine[1]}
					shutDownMachines $idmach
				fi
			fi
			unset mv
		done
	else
		print_log "Falta archivo de configuracion (.datalab)"
	fi
else
	doHelp
fi
