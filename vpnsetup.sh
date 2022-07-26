#!/bin/bash

PSK=$1
LeftId=$2
RightId=$3
RightIp=$4
LeftSubnet=$5
RightSubnet=$6




yum -y install openswan

echo "$LeftId  0.0.0.0 : PSK \"$PSK\"
" > /etc/ipsec.d/test.secrets


echo "conn test
    authby=secret
    auto=start
    left=%defaultroute
    leftsubnet=$LeftSubnet
    leftnexthop=%defaultroute
    rightid=$RightId
    right=$RightIp
    rightsubnet=$RightSubnet
    keyingtries=%forever
    ike=aes128-sha1;modp1024
    ikelifetime="28800"
    phase2alg=aes128-sha1;modp1024
    salifetime="3600"
    pfs=no
    phase2=esp
    type=tunnel
" > /etc/ipsec.d/test.conf







echo "1" > /proc/sys/net/ipv4/ip_forward
echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects
echo "0" > /proc/sys/net/ipv4/conf/all/send_redirects
echo "0" > /proc/sys/net/ipv4/conf/default/send_redirects
echo "0" > /proc/sys/net/ipv4/conf/eth0/send_redirects
echo "0" > /proc/sys/net/ipv4/conf/default/accept_redirects
echo "0" > /proc/sys/net/ipv4/conf/eth0/accept_redirects






service ipsec start
#ipsec verify


iptables -t mangle -A FORWARD -o eth0 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1387
