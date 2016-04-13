#! /bin/sh
# CUMULUS-AUTOPROVISIONING

# Enable passwordless sudo for cumulus user
echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus

# Add a public key for the cumulus user (change this to yours)
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzH+R+UhjVicUtI0daNUcedYhfvgT1dbZXgY33Ibm4MOo+X84Iwuzirm3QFnYf2O3uyZjNyrA6fj9qFE7Ekul4bD6PCstQupXPwfPMjns2M7tkHsKnLYjNxWNql/rCUxoH2B6nPyztcRCass3lIc2clfXkCY9Jtf7kgC2e/dmchywPV5PrFqtlHgZUnyoPyWBH7OjPLVxYwtCJn96sFkrjaG9QDOeoeiNvcGlk4DJp/g9L4f2AaEq69x8+gBTFUqAFsD8ecO941cM8sa1167rsRPx7SK3270Ji5EUF3lZsgpaiIgMhtIB/7QNTkN9ZjQBazxxlNVN6WthF8okb7OSt" >> /home/cumulus/.ssh/authorized_keys
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
