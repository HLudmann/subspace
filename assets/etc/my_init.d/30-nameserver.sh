#!/bin/sh
# Set DNS server
echo "nameserver ${SUBSPACE_NAMESERVER}" >/etc/resolv.conf