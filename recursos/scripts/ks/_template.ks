#version=RHEL7
# System authorization information
auth --enableshadow --passalgo=sha512
repo --name="EPEL" --baseurl=http://dl.fedoraproject.org/pub/epel/7/x86_64
# Run the Setup Agent on first boot
firstboot --enable
# Accept Eula
eula --agreed
reboot
# Use network installation
#url --url="http://192.168.122.1/repositorios/rhel7/"
#url --url="http://ricardo.carrillo:G00Y4.$@192.168.122.1/_REPO_/_ISOS_/"
#url --url="_METHOD_://ricardo.carrillo:G00Y4.$@_PROVIDER_/_REPO_/_ISOS__TYPE_/"
url --url="_METHOD_://_PROVIDER_/_REPO_/_ISOS_/_VERSION__TYPE_/"
#url --url ftp://username:password@server/patho 
# SELinux enabled
selinux --enforcing
# Firewall enabled
firewall --enabled
# Keyboard layouts
keyboard --vckeymap=la-latin1 --xlayouts='latam'
# System language
lang es_MX.UTF-8
# Network information
network  --bootproto=dhcp --device=eth0 --onboot=on --nameserver=_DNS_ --hostname=_HOSTNAME_._DOMAIN_ --gateway=_DEFAULTGW_
network  --bootproto=dhcp --device=eth1 --onboot=on --nameserver=_DNS_ --gateway=_ALTERNATEGW_

# Root password
#rootpw --iscrypted $6$CDAITFPF07YkQ/9p$3CIeCH21P4TV81A7GX7tRvM/cndInu/iwpDhInytNJeD7Q2oUE9AjGJshSedYkZnIm9OhAhbWH5K.knodcObe1
rootpw $1$PoOdXSpc$xEnqgRmaNnnx2obBBJ/Nh/ --iscrypted
services --enabled=NetworkManager,sshd,chronyd
# Evitando cualquier configuracion mediante interfaz grafica
user --name=super --groups=super,wheel --shell=/bin/bash --uid=500
skipx
text
# System timezone
timezone America/Mexico_City --isUtc
# Partition clearing information
#clearpart --drives=vda --all
clearpart --none --initlabel
# System bootloader configuration
bootloader --location=mbr --boot-drive="vda" --append="rhgb quiet crashkernel=auto"
autopart
%packages
@core
openldap-clients
openldap-servers
openldap
migrationtools
wget
vim-enhanced
net-tools
nfs-utils
rpcbind
vsftpd
autofs
net-tools
expect
bind
bind-chroot
mlocate
#axel
#htop
#iperf
#sysstat
#psacct
%end


%post --log=/root/ks-post.log
# We get the repo default configuration
/usr/bin/wget -c http://_PROVIDER_/recursos/forense-_ISOS_.repo -P /etc/yum.repos.d/
/usr/bin/wget -c http://_PROVIDER_/laboratorio/rht-vmctl  -P /usr/local/bin/
eth0=$(ip addr  | grep -i eth0  | awk '{print $2}' | head -2| tail -1  | awk -F "/" '{print $1}')
eth0_A=$(echo $eth0|cut -d"." -f1,2,3)
eth1=$(ip addr  | grep -i eth1  | awk '{print $2}' | head -2| tail -1  | awk -F "/" '{print $1}'|cut -d"." -f1,2,3)
eth1_B=$(echo $eth1|cut -d"." -f1,2,3)
sed -i -e "s/^source \.\/\.datalab*/source \/usr\/local\/bin\/\.datalab/g"  /usr/local/bin/rht-vmctl
# Here we are going to configure NFS access from _HOSTNAME_._DOMAIN_ server
echo "/var/ftp/pub/		${eth0_A}.0/24(ro,no_root_squash)" >> /etc/exports
echo "/var/ftp/pub/		${eth1_B}.0/24(ro,no_root_squash)" >> /etc/exports
# Definiendo los DNS's
echo "domain _DOMAIN_"> /etc/resolv.conf
echo "search _DOMAIN_">> /etc/resolv.conf
echo "options rotate" >> /etc/resolv.conf
echo "options timeout:1" >> /etc/resolv.conf
echo "nameserver _PROVIDER_" >> /etc/resolv.conf
%end
