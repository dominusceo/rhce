#! /bin/bash
USRHOME="/root/"
cd /etc/openldap/cacerts/
openssl genrsa -out CA.key 2048
expect  ${USRHOME}create-ca-classroom.exp 
openssl genrsa -out classroom-ldap.key 2048
expect ${USRHOME}create-ldapcrt-classroom.exp
openssl x509 -req -in classroom-ldap.csr  -CA CA.pem -CAkey CA.key -CAcreateserial -out classroom-ldap.crt  -days 1460 -sha256
cd ${USRHOME}
