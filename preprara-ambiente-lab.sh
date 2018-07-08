#creando carpetas
source ./.datalab
mkdir -pv /var/www/html/{$KSD,$RCD,$idirectory}
chcon -Rv /var/www/html/
setsebool -P httpd_read_user_content 1
cd net
for i in $(echo cracker remote-test example myorg.net redhat-labs) ; do sudo /usr/bin/virsh net-define $i.xml ; done
for i in $(echo cracker remote-test example myorg.net redhat-labs) ; do sudo /usr/bin/virsh net-autostart $i  ; done
for i in $(echo cracker remote-test example myorg.net redhat-labs) ; do sudo /usr/bin/virsh net-start $i ; done
