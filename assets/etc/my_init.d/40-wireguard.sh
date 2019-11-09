#!/bin/sh
#
# WireGuard (${SUBSPACE_IPV4_POOL})
#
if ! test -d /data/wireguard ; then
    mkdir /data/wireguard
    cd /data/wireguard

    mkdir clients
    touch clients/null.conf # So you can cat *.conf safely
    mkdir peers
    touch peers/null.conf # So you can cat *.conf safely

    # Generate public/private server keys.
    wg genkey | tee server.private | wg pubkey > server.public
fi

cat <<WGSERVER >/data/wireguard/server.conf
[Interface]
PrivateKey = $(cat /data/wireguard/server.private)
ListenPort = ${SUBSPACE_LISTEN_PORT}
WGSERVER
cat /data/wireguard/peers/*.conf >>/data/wireguard/server.conf

if ip link show wg0 2>/dev/null; then
    ip link del wg0
fi

ip link add wg0 type wireguard

ip addr add "${SUBSPACE_IPV4_GW}/${SUBSPACE_IPV4_CIDR}" dev wg0

ip addr add "${SUBSPACE_IPV6_GW}/${SUBSPACE_IPV6_CIDR}" dev wg0
wg setconf wg0 /data/wireguard/server.conf
ip link set wg0 up