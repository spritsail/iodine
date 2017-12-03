FROM alpine:3.7

LABEL maintainer="Adam Dodman <adam.dodman@gmx.com>"

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ iodine \
 && apk add --no-cache tini iptables net-tools

ADD start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 53/udp

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/start.sh"]
