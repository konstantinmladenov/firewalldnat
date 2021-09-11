#!/bin/bash
# Assuming that your Linux box has two NICs; eth0 attached to WAN and eth1 attached to LAN
# eth0 = outside
# eth1 = inside
# [LAN]----> eth1[GATEWAY]eth0 ---->WAN
# Run the following commands on LINUX box that will act as a firewall or NAT gateway
firewall-cmd --query-interface=eth0
firewall-cmd --query-interface=eth1
firewall-cmd --get-active-zone 
firewall-cmd --add-interface=eth0 --zone=external
firewall-cmd --add-interface=eth1 --zone=internal
firewall-cmd --zone=external --add-masquerade --permanent 
firewall-cmd --reload 
firewall-cmd --zone=external --query-masquerade 
# ip_forward is activated automatically if masquerading is enabled.
# To verify:
cat /proc/sys/net/ipv4/ip_forward 
# set masquerading to internal zone
firewall-cmd --zone=internal --add-masquerade --permanent
firewall-cmd --reload 
firewall-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -o eth0 -j MASQUERADE
firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i eth0 -o eth1 -j ACCEPT
firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
firewall-cmd --reload
