#! /bin/bash -x
mv=$1
executer=$(id -u)
source ./init-functions
if [ "$executer" == "0" ] ; then
	if [[ -n $mv || -n $2 || -n $3 ]] ; then
		if [ -f ./.datalab ] ; then 
			source ./.datalab
			NETNAME=$(getNetworkName $2) ; DOMAIN=$(getDomain $2) ; REPO=$(getDistro $3) ; ALTERNATEGW=$(getNetworkGW $2)
		#if [ -d ${rdirectory}$mv ] ; then echo "MV $mv already created!" && exit 1 ; fi
			mkdir -p ${vdirectory}$mv
			$(which qemu-img) create -f qcow2  $vdirectory${mv}/${mv}.img ${SIZE}G
			cat ${KICKSTARTPATH}/_template.ks > ${KICKSTARTPATH}/$mv.ks && restorecon ${KICKSTARTPATH}/$mv.ks 
			sed -i -e "s/_PROVIDER_/$PROVIDER/g ; s/_ISOS_/$REPO/g;s/_serverType_/$VERSION${TYPE}/g;s/_IDIRECTORY_/$idirectory/g" ${RESOPATH}/forense-$REPO.repo
			sed -i -e "s/_SERVER_/$mv/g" ${KICKSTARTPATH}/$mv.ks
			sed -i -e "s/_METHOD_/$METHOD/g" ${KICKSTARTPATH}/$mv.ks
			sed -i -e "s/_VERSION_/$VERSION/g" ${KICKSTARTPATH}/$mv.ks
			sed -i -e "s/_TYPE_/$TYPE/g" ${KICKSTARTPATH}/$mv.ks
			sed -i -e "s/_REPO_/$idirectory/g" ${KICKSTARTPATH}/$mv.ks
			sed -i -e "s/_ISOS_/$REPO/g" ${KICKSTARTPATH}/$mv.ks
			sed -i -e "s/_PROVIDER_/$PROVIDER/g" ${KICKSTARTPATH}/$mv.ks
			sed -i -e "s/_DNS_/$DNS/g" ${KICKSTARTPATH}/$mv.ks
			sed -i -e "s/_DOMAIN_/$DOMAIN/g" ${KICKSTARTPATH}/$mv.ks
			sed -i -e "s/_HOSTNAME_/$mv/g" ${KICKSTARTPATH}/$mv.ks
			sed -i -e "s/_DEFAULTGW_/$GATEWAY/g" ${KICKSTARTPATH}/$mv.ks
			sed -i -e "s/_ALTERNATEGW_/$ALTERNATEGW/g" ${KICKSTARTPATH}/$mv.ks
			#echo $(which virt-install) --connect=qemu:///system -n ${mv}.$DOMAIN -r $MEM --vcpus=1 -l $METHOD://$PROVIDER/${idirectory}/$REPO/$VERSION${TYPE}/ -x inst.ks=$METHOD://$PROVIDER/ks/$mv.ks --os-type=linux --os-variant=$(determinaOSVariant $OSVARIANT) --boot hd,network,menu=on --disk path=${vdirectory}${mv}/$mv.img,size=$SIZE,bus=virtio --graphics spice --noautoconsole -v --accelerate --network network:default,mac=$($(which python) generatemac.py) --network network:$NETNAME,mac=$MAC --description "Maquina virtual $mv" --autostart && echo "Virtual machine create process started...!!"
			 $(which virt-install) --connect=qemu:///system -n ${mv}.$DOMAIN -r $MEM --vcpus=1 -l $METHOD://$PROVIDER/${idirectory}/$REPO/$VERSION${TYPE}/ -x inst.ks=$METHOD://$PROVIDER/ks/$mv.ks --os-type=linux --os-variant=$(determinaOSVariant $OSVARIANT) --boot hd,network,menu=on --disk path=${vdirectory}${mv}/$mv.img,size=$SIZE,bus=virtio --graphics spice --noautoconsole -v --accelerate --network network:default,mac=$($(which python) generatemac.py) --network network:$NETNAME,mac=$MAC --description "Maquina virtual $mv" --autostart && echo "Virtual machine create process started...!!"
			sudo $(which virt-viewer) -a --domain-name ${mv}.$DOMAIN 2>/dev/null&
		else
			print_log  "Falta el archivo de configuracion principal (.datalab)"
		fi
	else
		doHelp
	fi
else
	doHelp
fi
