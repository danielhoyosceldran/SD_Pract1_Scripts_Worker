#!/bin/bash

hostname=$1
ip_master=$2
ip_masterI=$3

hostnamectl set-hostname $hostname

ln=$(grep -n "127.0.1.1" /etc/hosts | cut -d: -f1)

if [ -n "$ln" ]; then
	sed -i "${ln}s/.*/127.0.1.1\t$hostname/" /etc/hosts
fi

sed -i "/19.168/d" /etc/hosts

if [ -z "$(grep -n "$ip_master" /etc/hosts)" ]; then
	sed -i "${ln}s/.*/$ip_master\tmaster/" /etc/hosts
fi

if [ -z "$(grep -n "$ip_masterI" /etc/hosts)" ]; then
	sed -i "${ln}s/.*/$ip_masterI\tmasterI/" /etc/hosts
fi

if [ -z "$(grep 'gateway' /etc/network/interfaces)" ]; then
	ln=$(grep -n "iface ens3 inet static" /etc/network/interfaces | cut -d: -f1)
	if [ -n "$ln" ]; then
		sed -i "${ln}s/$/\n  gateway $ip_master/" /etc/network/interfaces
	fi
fi

systemctl restart networking
