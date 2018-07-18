#!/bin/bash
source ./.functions
# Validating/Installing  rsyslog service with ldap loggin
validating_rsyslog_ldap
# Verifiying iptables rules related ldap service, if exist any rule won't
# apply any rule, otherwise will be applied ldap rules.
verify_ldap_rules
echo "Cleaning ldap database..." && sleep 1
cd $DB_LDAP && rm -fv *.bdb log* __db.00* alock && sleep 1.2
echo "Creating DB_CONFIG initial configuration"
echo "#Transaction Log settings"
echo "set_lg_regionmax       31457280"              | tee ${DB_LDAP}/$DB_CONFIG
echo "set_lg_bsize           4194304"               | tee -a ${DB_LDAP}/$DB_CONFIG
echo "# one 16 GB cache"                            | tee -a ${DB_LDAP}/$DB_CONFIG
echo "set_cachesize          0   1610612736    1"   | tee -a ${DB_LDAP}/$DB_CONFIG
echo "set_flags              DB_LOG_AUTOREMOVE"     | tee -a ${DB_LDAP}/$DB_CONFIG
echo "set_lk_max_locks       1000000"               | tee -a ${DB_LDAP}/$DB_CONFIG
echo "set_lk_max_lockers     1000000"               | tee -a ${DB_LDAP}/$DB_CONFIG
echo "set_lk_max_objects     1000000"               | tee -a ${DB_LDAP}/$DB_CONFIG
echo "set_lg_max             20971520"              | tee -a ${DB_LDAP}/$DB_CONFIG
echo "set_lg_dir             /var/lib/ldap"         | tee -a ${DB_LDAP}/$DB_CONFIG
chown ldap.ldap $DB_LDAP/DB_*
chmod 700 $DB_LDAP/*
echo "Eliminando/Creando configuracion"
cd $ETC_SLAPD && rm -rfv slapd.d/ && sleep 1.2
echo "Reinsitalando paquetes..." && sleep 1
installing_ldap_packages
systemctl restart slapd && sleep 1.2 && systemctl enable slapd
cd /etc/openldap/schema/
for i in $(echo cosine inetorgperson nis misc openldap ppolicy) ; do
    ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f ${i}.ldif
done
cd $HOME_LDIFSC
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 00_hdb_monitor_log.ldif
chown -Rv ldap.ldap /etc/openldap/slapd.d/cn\=config/cn\=schema/*
chmod -Rv 600 /etc/openldap/slapd.d/cn\=config/cn\=schema/*
cd /etc/openldap/slapd.d/cn\=config/cn\=schema/
chcon --reference=cn\=\{2\}inetorgperson.ldif cn\=\{*
cd $HOME_LDIFSC && echo "Restarting services" && sleep 1.2
systemctl stop slapd  &&  systemctl start slapd && systemctl status slapd && sleep 1.2
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 01_sinlimite-busqueda.ldif
cd $HOME_LDIFSD
ldapadd -x -h $(hostname) -D "cn=manager,dc=example,dc=com" -f 02_rama_inicial.ldif -w redhat
cd $HOME_LDIFSC
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 03a_modulo-replicacion.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 03b_overlay-replicacion.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 03c_modulo-replicacion.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 04_syncrep-maestro.ldif
cd $HOME_LDIFSD
ldapadd -x -h $(hostname) -D "cn=manager,dc=example,dc=com" -f 04d_usuario-rep.ldif -w redhat
cd $HOME_LDIFSC
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 05_acl-usuarios.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 07a_agregar_indices.ldif
#ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 08a_activacion_tls_01.ldif
