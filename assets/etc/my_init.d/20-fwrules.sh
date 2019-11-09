#!/bin/sh
# ipv4
if ! /sbin/iptables -t nat --check POSTROUTING -s ${SUBSPACE_IPV4_POOL} -j MASQUERADE ; then
    /sbin/iptables -t nat --append POSTROUTING -s ${SUBSPACE_IPV4_POOL} -j MASQUERADE
fi

if ! /sbin/iptables --check FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT ; then
    /sbin/iptables --append FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
fi

if ! /sbin/iptables --check FORWARD -s ${SUBSPACE_IPV4_POOL} -j ACCEPT ; then
    /sbin/iptables --append FORWARD -s ${SUBSPACE_IPV4_POOL} -j ACCEPT
fi

if [[ ${SUBSPACE_IPV6_NAT_ENABLED-} -gt 0 ]]; then
# ipv6
    if ! /sbin/ip6tables -t nat --check POSTROUTING -s ${SUBSPACE_IPV6_POOL} -j MASQUERADE ; then
        /sbin/ip6tables -t nat --append POSTROUTING -s ${SUBSPACE_IPV6_POOL} -j MASQUERADE
    fi

    if ! /sbin/ip6tables --check FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT ; then
        /sbin/ip6tables --append FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
    fi

    if ! /sbin/ip6tables --check FORWARD -s ${SUBSPACE_IPV6_POOL} -j ACCEPT ; then
        /sbin/ip6tables --append FORWARD -s ${SUBSPACE_IPV6_POOL} -j ACCEPT
    fi
fi


# ipv4 - DNS Leak Protection
if ! /sbin/iptables -t nat --check OUTPUT -s ${SUBSPACE_IPV4_POOL} -p udp --dport 53 -j DNAT --to "${SUBSPACE_IPV4_GW}":53 ; then
    /sbin/iptables -t nat --append OUTPUT -s ${SUBSPACE_IPV4_POOL} -p udp --dport 53 -j DNAT --to "${SUBSPACE_IPV4_GW}":53
fi

if ! /sbin/iptables -t nat --check OUTPUT -s ${SUBSPACE_IPV4_POOL} -p tcp --dport 53 -j DNAT --to "${SUBSPACE_IPV4_GW}":53 ; then
    /sbin/iptables -t nat --append OUTPUT -s ${SUBSPACE_IPV4_POOL} -p tcp --dport 53 -j DNAT --to "${SUBSPACE_IPV4_GW}":53
fi

# ipv6 - DNS Leak Protection
if ! /sbin/ip6tables --wait -t nat --check OUTPUT -s ${SUBSPACE_IPV6_POOL} -p udp --dport 53 -j DNAT --to "${SUBSPACE_IPV6_GW}" ; then
    /sbin/ip6tables --wait -t nat --append OUTPUT -s ${SUBSPACE_IPV6_POOL} -p udp --dport 53 -j DNAT --to "${SUBSPACE_IPV6_GW}"
fi

if ! /sbin/ip6tables --wait -t nat --check OUTPUT -s ${SUBSPACE_IPV6_POOL} -p tcp --dport 53 -j DNAT --to "${SUBSPACE_IPV6_GW}" ; then
    /sbin/ip6tables --wait -t nat --append OUTPUT -s ${SUBSPACE_IPV6_POOL} -p tcp --dport 53 -j DNAT --to "${SUBSPACE_IPV6_GW}"
fi