FROM frolvlad/alpine-glibc:alpine-3.4

MAINTAINER "Adam Dodman <adam.dodman@gmx.com>"

ADD start.sh /

#Add deps, download and extract patchelf, download source code, patch it, update library location with patchelf

RUN apk add --no-cache ca-certificates openssl libstdc++ net-tools \
 && wget -qO- https://github.com/strothj/alpine-patchelf/releases/download/0.9/0.9.tar.gz | tar xz \
 && cd /tmp && wget -qO- https://www.archlinux.org/packages/community/x86_64/iodine/download/ | tar xJC /tmp \
 && mv /tmp/usr/bin/iodined /usr/bin/iodined \
 && patchelf --set-interpreter /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /usr/bin/iodined \
 && rm -rf /usr/bin/patchelf /tmp/* \
 && apk del --no-cache ca-certificates openssl libstdc++\
 && chmod +x /start.sh

EXPOSE 53/udp

CMD ["/start.sh"]
