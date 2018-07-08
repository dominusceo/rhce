PS3='Elige una opcion:'
source ./init-functions
executer=$(verify_user)
if [ "$executer" == "0" ] ; then
	if [ -f ./.datalab ] ; then
		source ./.datalab
		options=($(getNodes live ; getNodes dead) "Apagar todas las maquinas virtuales" "Salir")
		select opt in "${options[@]}" ;do
			case $REPLY in
				[123])
					mv="$opt"
					nameMachine=$(validaNameMachine $mv)
					domain=$(getDomainMachine $mv)
					if [[ "$nameMachine" != "null" ]] ; then
                                	        shutDownMachines $mv $domain
					else
                	                        machine=$(getNameMachineId $mv)
        	                                idmach=${machine[0]}
	                                        namema=${machine[1]}
                                        	shutDownMachines $idmach
                               		fi
					;;
				4)
	                                for i in $(getNodes live); do
        	                                domain=$(getDomainMachine $i)
                	                        shutDownMachines $i $domain
                        	        done
					;;
				5)
					print_log "Salir"
            				break
					;;
				*)
				       	print_log "Opcion invalida"
					;;
   		 	esac
		done
	else
		print_log "Falta archivo de configuracion (.datalab)"
	fi
else
        doHelp
fi
