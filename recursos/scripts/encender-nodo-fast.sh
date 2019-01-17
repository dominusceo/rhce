#! /bin/bash
PS3='Elige una opcion:'
source ./init-functions
executer=$(verify_user)
if [ "$executer" == "0" ] ; then
        if [ -f ./.datalab ] ; then
                source ./.datalab
		if [[ ! -z $1 && "$1" != "" ]] ; then
			setPowerUPMachine $1;
		else
			print_log "You must pass a machine name for powerup it"
		fi
        else
                print_log "Falta archivo de configuracion (.datalab)"
        fi
else
        doHelp
fi
