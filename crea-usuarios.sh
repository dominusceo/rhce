# Create users
/bin/mkdir -pv /home/guests
for i in $(seq 1 25) ; do 
	/sbin/useradd -d /home/guests/ldapuser${i} ldapuser${i}
	echo "redhat" | /bin/passwd --stdin ldapuser${i}
done
