ARG IPTABLES_VER=1.8.0
ARG ZLIB_VER=1.2.11
ARG IODINE_VER=0.7.0

FROM spritsail/debian-builder:stretch-slim as builder

ARG IPTABLES_VER
ARG ZLIB_VER
ARG IODINE_VER

WORKDIR /tmp/iptables

RUN apt-get -y update \
 && apt-get -y install libmnl-dev libnftnl-dev bison flex zlib1g-dev tree \
 && curl -q "http://ftp.netfilter.org/pub/iptables/iptables-${IPTABLES_VER}.tar.bz2" | \
        tar xj --strip-components=1 \
 && ./configure \
      --prefix=/usr \
      --sbindir=/usr/bin \
      --sysconfdir=/etc \
      --disable-dependency-tracking \
      --without-kernel \
      --disable-shared \
      --disable-nftables \
      --disable-connlabel \
      --disable-libipq \
      --disable-bnf-compiler \
      --disable-nfsynproxy \
 && make \
 && DESTDIR="$PWD/out" make install \
 && mkdir -p /output/usr/lib /output/run \
 #Run directory fixes spritsail/iodine issue #9
 && mv "out/usr/bin/" /output/usr/bin/

WORKDIR /tmp/zlib

RUN curl -fsSL "https://github.com/madler/zlib/archive/v${ZLIB_VER}.tar.gz" | \
        tar xz --strip-components=1 \
 && ./configure \
      --prefix=/usr \
      --libdir=/usr/lib \
 && make \
 && DESTDIR="$PWD/out" make install \
 && find out/usr/lib -name 'libz.so*' -exec mv {} /output/usr/lib \;

WORKDIR /tmp/iodine

RUN curl -fsSL "https://code.kryo.se/iodine/iodine-${IODINE_VER}.tar.gz" | \
        tar xz  --strip-components=1 \
 && make \
 && mv bin/iodine* /output/usr/bin

ADD start.sh /output/usr/local/bin/start-iodined
RUN chmod +x /output/usr/local/bin/start-iodined

#===============

FROM spritsail/busybox

ARG IODINE_VER
ARG ZLIB_VER
ARG IPTABLES_VER

LABEL maintainer="Spritsail <iodine@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Iodine" \
      org.label-schema.url="http://code.kryo.se/iodine/" \
      org.label-schema.description="Tunnel IPv4 data over DNS" \
      org.label-schema.version=${IODINE_VER} \
      io.spritsail.version.iodine=${IODINE_VER} \
      io.spritsail.version.zlib=${ZLIB_VER} \
      io.spritsail.version.iptables=${IPTABLES_VER}

COPY --from=builder /output/ /

EXPOSE 53/udp

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/start-iodined"]
