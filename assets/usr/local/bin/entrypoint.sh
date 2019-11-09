#!/bin/bash
set -eux
set -o pipefail

# Require environment variables.
if [ -z "${SUBSPACE_HTTP_HOST-}" ] ; then
    export SUBSPACE_HTTP_HOST=$HOSTNAME
fi
# Optional environment variables.
if [ -z "${SUBSPACE_BACKLINK-}" ] ; then
    export SUBSPACE_BACKLINK=""
fi

if [ -z "${SUBSPACE_IPV4_POOL-}" ] ; then
    export SUBSPACE_IPV4_POOL="10.99.97.0/24"
fi
if [ -z "${SUBSPACE_IPV6_POOL-}" ] ; then
    export SUBSPACE_IPV6_POOL="fd00::10:97:0/112"
fi
if [ -z "${SUBSPACE_NAMESERVER-}" ] ; then
    export SUBSPACE_NAMESERVER="1.1.1.1"
fi

if [ -z "${SUBSPACE_LETSENCRYPT-}" ] ; then
    export SUBSPACE_LETSENCRYPT="true"
fi

if [ -z "${SUBSPACE_HTTP_ADDR-}" ] ; then
    export SUBSPACE_HTTP_ADDR=":80"
fi

if [ -z "${SUBSPACE_LISTEN_PORT-}" ] ; then
    export SUBSPACE_LISTEN_PORT="51820"
fi

if [ -z "${SUBSPACE_HTTP_INSECURE-}" ] ; then
    export SUBSPACE_HTTP_INSECURE="false"
fi

if [ -z "${SUBSPACE_IPV4_GW-}" ] ; then
    SUBSPACE_IPV4_PREF=$(echo ${SUBSPACE_IPV4_POOL-} | cut -d '/' -f1 |sed 's/.0$/./g' )
    export SUBSPACE_IPV4_PREF
    export SUBSPACE_IPV4_GW=${SUBSPACE_IPV4_PREF-}1

fi
if [ -z "${SUBSPACE_IPV6_GW-}" ] ; then
    SUBSPACE_IPV6_PREF=$(echo ${SUBSPACE_IPV6_POOL-} | cut -d '/' -f1 |sed 's/:0$/:/g' )
    export SUBSPACE_IPV6_PREF
  	export SUBSPACE_IPV6_GW=${SUBSPACE_IPV6_PREF-}1
fi

if [ -z "${SUBSPACE_IPV6_NAT_ENABLED-}" ] ; then
    export SUBSPACE_IPV6_NAT_ENABLED=1
fi

SUBSPACE_IPV4_CIDR=$(echo ${SUBSPACE_IPV4_POOL-} |cut -d '/' -f2)
export SUBSPACE_IPV4_CIDR

SUBSPACE_IPV6_CIDR=$(echo ${SUBSPACE_IPV6_POOL-} |cut -d '/' -f2)
export SUBSPACE_IPV6_CIDR

exec "$@"