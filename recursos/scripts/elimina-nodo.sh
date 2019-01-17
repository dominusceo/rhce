#! /bin/bash
PS3='Elige una opcion:'
source ./init-functions
executer=$(verify_user)
if [ "$executer" == "0" ] ; then
        if [ -f ./.datalab ] ; then
                source ./.datalab
		kill_machines;
        else
                echo "Falta archivo de configuracion (.datalab)"
        fi
else
        doHelp
fi
