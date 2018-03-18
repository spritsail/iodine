FROM spritsail/debian-builder:stretch-slim as builder

ARG IPTABLES_VER=1.6.1
ARG IODINE_VER=0.7.0

WORKDIR /tmp/iptables

RUN apt-get -y update \
 && apt-get -y install libmnl-dev libnftnl-dev bison flex zlib1g-dev \
 && curl -q "http://ftp.netfilter.org/pub/iptables/iptables-${IPTABLES_VER}.tar.bz2" | \
        tar xj --strip-components=1 \
 && ./configure \
      --prefix=/usr \
      --sbindir=/usr/bin \
      --sysconfdir=/etc \
      --disable-dependecy-tracking \
      --without-kernel \
      --disable-shared \
      --disable-nftables \
      --disable-connlabel \
      --disable-libipq \
      --disable-bnf-compiler \
      --disable-nfsynproxy \
 && make \
 && DESTDIR="$PWD/out" make install \
 && mkdir -p /output/usr \
 && mv "out/usr/bin/" /output/usr/bin/

WORKDIR /tmp/iodine

RUN curl -q "http://code.kryo.se/iodine/iodine-${IODINE_VER}.tar.gz" | \
        tar xz  --strip-components=1 \
 && make \
 && mv bin/iodine* /output/usr/bin

ADD start.sh /output/usr/bin
RUN chmod +x /output/usr/bin/start.sh

## MASSIVE HACK NEEDS REPLACING
RUN mkdir -p /output/usr/lib \
 && cp /usr/lib/x86_64-linux-gnu/libz.so /output/usr/lib/libz.so.1

#===============

FROM spritsail/busybox

ARG IODINE_VER

LABEL maintainer="Spritsail <iodine@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Iodine" \
      org.label-schema.url="http://code.kryo.se/iodine/" \
      org.label-schema.description="Tunnel IPv4 data over DNS" \
      org.label-schema.version=${IODINE_VER}

COPY --from=builder /output/ /

EXPOSE 53/udp

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/bin/start.sh"]
