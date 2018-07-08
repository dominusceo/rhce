################################
### Creating th LAB - script ###
################################
#!/bin/sh
## Loading Variables
useradd ldap
IP_ADDR=192.168.1.230
SHORTNAME=freeipa
DOMAIN=example.com
HOSTNAME=$SHORTNAME.$DOMAIN
REALM=$(echo $DOMAIN|tr "[[:lower:]]" "[[:lower:]]")
LDAPHOME=/home/ldap
REPONFS=/srv/nfs
REPOSMB=/srv/samba
REPOPUB=/srv/public

mkdir $LDAPHOME $REPONFS $REPOSMB $REPOPUB
## Starting and Enabling Firewalld
systemctl enable firewalld ; systemctl start firewalld
## Masquerade the Network
firewall-cmd --add-masquerade --permanent; firewall-cmd --reload
## Install IPA Server and Others tools
yum install -y ipa-server ipa-server-dns bind-dyndb-ldap
## Setting the right config on hosts file
echo "$IP_ADDR $HOSTNAME $SHORTNAME" >> /etc/hosts
# Installing everything unattended
ipa-server-install --domain=$DOMAIN --realm=$REALM --ds-password=password --admin-password=password --hostname=$HOSTNAME --ip-address=$IP_ADDR --reverse-zone=1.168.192.in-addr.arpa. --forwarder=8.8.8.8 --allow-zone-overlap --setup-dns --unattended
# Opening ports
for i in http https ldap ldaps kerberos kpasswd dns ntp; do firewall-cmd --permanent --add-service $i; done
firewall-cmd --reload
# FTP installation
yum install -y vsftpd
systemctl enable vsftpd ; systemctl start vsftpd
firewall-cmd --add-service ftp --permanent; firewall-cmd --reload
## CA cert
cp /root/cacert.p12 /var/ftp/pub
cp /etc/ipa/ca.crt /var/ftp/pub
# Kerberos ticket for the rest of the configuration
echo -n 'password' | kinit admin
# Changing default home directory on new user
ipa config-mod --homedirectory=$LDAPHOME
# Configuring NFS
yum -y install nfs-utils
systemctl enable rpcbind ; systemctl enable nfs-server
systemctl start rpcbind ; systemctl start nfs-server
chown nfsnobody $REPONFS
echo "$LDAPHOME *(rw)" >> /etc/exports
echo "$REPOSMB *(rw)" >> /etc/exports
exportfs -vr
# Firewall Change for NFS
for i in $( echo mountd rpc-bind nfs); do firewall-cmd --permanent --add-service=$i ; done
firewall-cmd --reload
cd $LDAPHOME
for i in $(seq 1 5) ; do 
	mkdir ldapuser$i
	# Creating LDAP users
	ipa user-add ldapuser$i --first=ldapuser$i --last=ldapuser$i
	echo 'password' | ipa passwd ldapuser${i}
	chown ldapuser${i} ldapuser${i}
done
# Fixing resolv.conf
echo "nameserver $PROVIDER" >> /etc/resolv.conf
# Samba Configuration
mkdir $REPONFS
chmod 2775 $REPONFS
mkdir ${REPOPUB}
chmod 777 ${REPOPUB}
touch ${REPOSMB}samba-user-${1,2,3}
# Creating the group
groupadd userssamba
chown -R :userssamba $REPOSMB
# Installing Samba
yum -y install samba
systemctl enable smb
systemctl enable nmb

# Creating usernames
for i in $(seq 1 3) ; do
	useradd sambauser${i} -G userssamba
	printf "password\npassword\n" | smbpasswd -a -s sambauser$i
done
# Firewall for Samba
firewall-cmd --add-service samba --permanent
firewall-cmd --reload

# Editing the smb.conf
echo "[data]" >> /etc/samba/smb.conf
echo "comment = data share" >> /etc/samba/smb.conf
echo "path = ${REPOSMB}" >> /etc/samba/smb.conf
echo "write list = @userssamba" >> /etc/samba/smb.conf

echo "map to guest = bad user" >> /etc/samba/smb.conf
echo "[public]" >> /etc/samba/smb.conf
echo "comment = Public Directory" >> /etc/samba/smb.conf
echo "path = $REPOPUB" >> /etc/samba/smb.conf
echo "browseable = yes" >> /etc/samba/smb.conf
echo "writable = yes" >> /etc/samba/smb.conf
echo "guest ok = yes" >> /etc/samba/smb.conf
echo "read only = no" >> /etc/samba/smb.conf

semanage fcontext -a -t samba_share_t "/srv/samba(/.*)?"
semanage fcontext -a -t samba_share_t "/srv/public(/.*)?"
restorecon -Rv /srv

systemctl restart smb
systemctl restart nmb

nmcli connection modify eth0 ipv4.dns ${IP_ADDR}
nmcli connection down eth0
nmcli connection up eth0
wget -c http://192.168.122.2/recursos/forense-centos.repo -P /etc/yum.repos.d/forense-centos.repo
systemctl restart vsftpd
