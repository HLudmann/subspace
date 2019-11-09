#!/bin/sh
# dnsmasq service
cat <<DNSMASQ >/etc/dnsmasq.conf
# Only listen on necessary addresses.
listen-address=127.0.0.1,${SUBSPACE_IPV4_GW},${SUBSPACE_IPV6_GW}
# Never forward plain names (without a dot or domain part)
domain-needed
# Never forward addresses in the non-routed address spaces.
bogus-priv
DNSMASQ