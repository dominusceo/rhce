PS3='Elige una opcion:'
source ./init-functions
executer=$(verify_user)
if [ "$executer" == "0" ] ; then
	if [ -f ./.datalab ] ; then
		source ./.datalab
		echo  ".:: O P E R A C I O N E S  L A B O R A T O R I O RHCE ::."
		options=( "Ingresar maquina virtual" "Iniciar maquina virtual"  "Eliminar maquina virtual" "Encender todas las maquinas virtuales" "Apagar todas las maquinas virtuales" "Crear MV" "Salir")
		select opt in "${options[@]}" ;do
			case $REPLY in
				1)
					list_live_machines "$opt"
					;;
				2)
					list_dead_machines "$opt"
					;;
				3)
					kill_machines
					;;
				4)
					print_log "Encender todas las mv"
					;;

				*)
					print_log "salida" && exit && break
					;;
   			esac
		done
	else
		print_log "Falta archivo de configuracion (.datalab)"
	fi
else
        doHelp
fi
