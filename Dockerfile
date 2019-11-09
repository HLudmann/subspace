FROM phusion/baseimage:0.11
LABEL maintainer="github.com/soundscapecloud/soundscape"

COPY ./assets/ /

ENV DEBIAN_FRONTEND noninteractive

RUN chmod +x /usr/bin/subspace \
             /usr/local/bin/entrypoint.sh \
             /etc/service/dnsmasq/run \
             /etc/service/dnsmasq/log/run \
             /etc/service/subspace/run \
             /etc/service/subspace/log/run

RUN /sbin/install_clean iproute2 iptables dnsmasq socat

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD [ "/sbin/my_init" ]
