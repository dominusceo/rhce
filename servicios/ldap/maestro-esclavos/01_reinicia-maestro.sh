#!/bin/bash
HOME_LDAP=/root/maestro-esclavo
DB_LDAP=/var/lib/ldap
DB_CONFIG=DB_CONFIG
SLAPD=$(ps -fea | grep -i slapd|awk '{print $2}')
ETC_SLAPD="/etc/openldap"
echo "Reiniciando base de datos..." && sleep 1
cd $DB_LDAP && rm -fv *.bdb log* __db.00* alock && sleep 1.2
echo "Creando configuraciones DB_CONFIG"
cat << __EOF__ > ${DB_LDAP}/$DB_CONFIG
#Transaction Log settings
set_lg_regionmax        31457280
set_lg_bsize            4194304
# one 16 GB cache
set_cachesize          0   1610612736        1
set_flags              DB_LOG_AUTOREMOVE
set_lk_max_locks        1000000
set_lk_max_lockers      1000000
set_lk_max_objects      1000000
set_lg_max              20971520
set_lg_dir              /var/lib/ldap
__EOF__
chown ldap.ldap $DB_LDAP/DB_*
chmod 700 $DB_LDAP/*
echo "Eliminando/Creando configuracion"
cd $ETC_SLAPD && rm -rfv slapd.d/ && sleep 1.2
echo "Reinsitalando paquetes..." && sleep 1
yum -y reinstall openldap*
systemctl restart slapd && sleep 1.2 && systemctl enable slapd
cd /etc/openldap/schema/
for i in $(echo cosine inetorgperson nis misc openldap ppolicy) ; do ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f ${i}.ldif; done
cd $HOME_LDAP
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 00_hdb_monitor_log.ldif
chown -Rv ldap.ldap /etc/openldap/slapd.d/cn\=config/cn\=schema/*
chmod -Rv 600 /etc/openldap/slapd.d/cn\=config/cn\=schema/*
cd /etc/openldap/slapd.d/cn\=config/cn\=schema/                                                        
chcon --reference=cn\=\{2\}inetorgperson.ldif cn\=\{*
cd $HOME_LDAP
echo "Reiniciando servicios" && sleep 1.2
systemctl stop slapd  &&  systemctl start slapd && systemctl status slapd && sleep 1.2
#R3pl1c4c10n.U3R
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 01_sinlimite-busqueda.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 03a_modulo-replicacion.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 03b_overlay-replicacion.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 03c_modulo-replicacion.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 04_syncrep-maestro.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 05_total-acl.ldif
ldapadd -x -h $(hostname) -D "cn=manager,dc=example,dc=com" -f 02_rama_inicial.ldif -w redhat
ldapadd -x -h $(hostname) -D "cn=manager,dc=example,dc=com" -f 04d_usuario-rep.ldif -w redhat
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 07a_agregar_indices.ldif
#ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 08a_activacion_tls_01.ldif
