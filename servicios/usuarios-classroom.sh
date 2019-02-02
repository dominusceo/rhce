for i in $(seq 1 10) ; do 
last=$(ldapsearch  -x -h localhost -b "dc=example,dc=com" -LLL  uidNumber | grep -i uidNumber: | awk '{print $2}'| sort -n | tail -1 )
a=$(($last+1))
cat > /tmp/ldapuser${i}.ldif<<USUARIOS
dn: uid=ldapuser${i},ou=People,dc=example,dc=com
mailHost: correo.example.com
mailRoutingAddress: local
objectClass: posixAccount
objectClass: top
objectClass: ExAccount
objectClass: inetOrgPerson
objectClass: shadowAccount
objectClass: inetLocalMailRecipient
loginShell: /bin/bash
gidNumber: 11
uidNumber: $a
mailLocalAddress: ldapuser${i}
uid: ldapuser${i}
mail: ldapuser${i}@example.com
telephoneNumber: 5558984605
personalTitle: Cuenta de ldapuser ldapuser${i}
postalAddress: AVENIDA SIEMPRE VIVA No. 1000 EDIF. A PB, COL. BARRIO BAJO, SPRINFIELD
cn: PATERNO MATERNO USUARIO${i}
homePostalAddress: AVENIDA SIEMPRE VIVA No. 1000 EDIF. A PB, COL. BARRIO BAJO, SPRINFIELD
gecos: Ldap Test User ${i}
ou: INSTITUTO NACIONAL EXAMPLE COM 
st: CIUDAD DE MEXICO
l: SPRINFIELD
c: MX
sn: PATERNO MATERNO
givenName: USUARIO${i}
o: INSTITUTO NACIONAL EXAMPLE COM
postalCode: 14610
homeDirectory: /home/ldapuser${i}
USUARIOS
	ldapadd -x -h localhost -D "cn=manager,dc=example,dc=com" -f "/tmp/ldapuser${i}.ldif" -w redhat
	ldappasswd -x -h localhost -D "cn=manager,dc=example,dc=com" "uid=ldapuser${i},ou=People,dc=example,dc=com" -w redhat -s kerberos
done
