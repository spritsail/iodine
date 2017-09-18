FROM alpine:edge
LABEL maintainer="Adam Dodman <adam.dodman@gmx.com>"

RUN apk --no-cache iodine tini iptables net-tools

ADD start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 53/udp

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/start.sh"]
