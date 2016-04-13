#! /bin/sh
# CUMULUS-AUTOPROVISIONING

# Enable passwordless sudo for cumulus user
echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus

# Add a public key for the cumulus user
wget http://oob-mgmt-server/id_rsa.pub -o /dev/null -O - | cat >> /home/cumulus/.ssh/authorized_keys
chmod 700 -R /home/cumulus/.ssh
chown cumulus:cumulus -R /home/cumulus/.ssh

# License the switch
cl-license -i http://oob-mgmt-server/`hostname`.lic

# Restart switchd for license to take effect
service switchd restart

# Set all ports on the device as admin up
for i in `ls /sys/class/net -1 | grep swp`; do  ip link set up $i; done;

# Grab the ptm file and restart ptm
wget http://oob-mgmt-server/topology.dot -O /etc/ptm.d/topology.dot
service ptmd restart

# CUMULUS-AUTOPROVISIONING
exit 0
