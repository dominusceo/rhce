#!/bin/bash
HOME_LDAP=/root/maestro-esclavo
DB_LDAP=/var/lib/ldap
DB_CONFIG=DB_CONFIG
SLAPD=$(ps -fea | grep -i slapd|awk '{print $2}')
ETC_SLAPD="/etc/openldap"

function verify_ldap_rules(){
    verify=$(iptables -L -n | egrep -i -e "389|636")
    if [[ -z "$verify"  && "$verify" = ""  ]] ; then
        firewall-cmd --add-service={ldap,ldaps}
        firewall-cmd --add-service={ldap,ldaps} –permanent
        firewall-cmd –reload
    fi

}

function validating_rsyslog_ldap(){

    verify=$(egrep -i -e "ldap\.log")
    if [[ -z "$verify"  && "$verify" = ""  ]] ; then
        echo "local4.* /var/log/ldap.log" | tee -a /etc/rsyslog.conf
        systemctl restart rsyslog && systemctl status rsyslog  &&  systemctl restart slapd
    fi

}
echo "Reiniciando base de datos..." && sleep 1
cd $DB_LDAP && rm -fv *.bdb log* __db.00* alock && sleep 1.2
echo "Creando configuraciones DB_CONFIG"
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

# Verifiying iptables rules related ldap service, if exist any rule won't 
# apply any rule, otherwise will be applied ldap rules.
verify_ldap_rules
chown -Rv ldap.ldap $DB_LDAP
chmod -Rv 700 $DB_LDAP/*
echo "Deleting/Creating ldap configuration..."
# Installing ldap related packages
yum -y reinstall openldap*
# Starting && enabling ldap service
systemctl restart slapd && sleep 1.2 && systemctl enable slapd
# Loading into configuration, ldap modules
cd /etc/openldap/schema/
for i in $(echo cosine inetorgperson nis misc openldap ppolicy) ; do 
        ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f ${i}.ldif; 
done

# Verifiying ldap loggin information, so we enable these feature
# adding configuration into rsyslog configuration file.
validating_rsyslog_ldap

# Creating ldap structure according to EXAMPLE organization (example.com)
cd $HOME_LDAP
ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f 00_hdb_monitor_log.ldif
chown -Rv ldap.ldap /etc/openldap/slapd.d/cn\=config/cn\=schema/*
chmod -Rv 600 /etc/openldap/slapd.d/cn\=config/cn\=schema/*
cd /etc/openldap/slapd.d/cn\=config/cn\=schema/                                                        
chcon --reference=cn\=\{2\}inetorgperson.ldif cn\=\{*
cd $HOME_LDAP
echo "Restarting services" && sleep 1.2
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
