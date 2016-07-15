FROM alpine:3.4

MAINTAINER "Adam Dodman <adam.dodman@gmx.com>"

ADD start.sh /

RUN apk add --no-cache ca-certificates g++ linux-headers lzo make  openssl zlib-dev \
 && wget http://code.kryo.se/iodine/iodine-0.7.0.tar.gz \
 && tar -xzf iodine-0.7.0.tar.gz \
 && cd iodine-0.7.0/src \
 && wget -qO- https://raw.githubusercontent.com/openwrt/packages/master/net/iodine/patches/100-musl-compatibility.patch | patch \
 && cd .. && make && make install \
 && cd .. && rm -rf iodine-0.7.0* \
 && apk del ca-certificates g++ linux-headers make openssl zlib-dev \
 && chmod +x /start.sh

EXPOSE 53/udp

CMD ["/start.sh"]
