ONIE, ZTP, and PTM Demo
=======================
This demo demonstrates how to configure an out of band management network to automatically install and configure Cumulus Linux using [Zero Touch Provisioning](https://docs.cumulusnetworks.com/display/DOCS/Zero+Touch+Provisioning+-+ZTP), and validate the cabling of the switches using [Prescriptive Topology Manager](https://docs.cumulusnetworks.com/display/DOCS/Prescriptive+Topology+Manager+-+PTM).

This demo is written for the [cldemo-vagrant](https://github.com/cumulusnetworks/cldemo-vagrant) reference topology.


Quickstart: Run the demo
------------------------
(This assumes you are running Ansible 1.9.4 and Vagrant 1.8.4 on your host.)

    git clone https://github.com/cumulusnetworks/cldemo-vagrant
    cd cldemo-vagrant
    vagrant up oob-mgmt-server oob-mgmt-switch leaf01 leaf02 spine01 spine02 server01 server02
    vagrant ssh oob-mgmt-server
    sudo su - cumulus
    git clone https://github.com/cumulusnetworks/cldemo-onie-ztp-ptm
    cd cldemo-onie-ztp-ptm
    sudo apt-get update
    sudo apt-get install -qy apache2 isc-dhcp-server bind9
    sudo cp ./etc/dhcp/* /etc/dhcp
    sudo cp ./etc/bind/zones/* /etc/bind/zones
    sudo cp ./etc/bind/named.conf.options /etc/bind
    sudo cp ./var/www/* /var/www
    sudo service isc-dhcp-server restart
    ssh leaf01
    sudo su
    ifdown eth0; ifup eth0
    exit
    ptmctl


Topology
--------
This demo runs on a spine-leaf topology with two single-attached hosts. Each device's management interface is connected to an out-of-band management switch and bridged with the out-of-band management server from which we run Ansible.

             +------------+       +------------+
             | spine01    |       | spine02    |
             |            |       |            |
             +------------+       +------------+
             swp1 |    swp2 \   / swp1    | swp2
                  |           X           |
            swp51 |   swp52 /   \ swp51   | swp52
             +------------+       +------------+
             | leaf01     |       | leaf02     |
             |            |       |            |
             +------------+       +------------+
             swp1 |                       | swp2
                  |                       |
             eth1 |                       | eth2
             +------------+       +------------+
             | server01   |       | server02   |
             |            |       |            |
             +------------+       +------------+
