FROM frolvlad/alpine-glibc:alpine-3.5

MAINTAINER "Adam Dodman <adam.dodman@gmx.com>"

ADD start.sh /

#Add deps, download and extract patchelf, download source code, patch it, update library location with patchelf

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \ 
 && apk add --no-cache ca-certificates openssl libstdc++ net-tools iptables patchelf@testing \
 && cd /tmp && wget -qO- https://www.archlinux.org/packages/community/x86_64/iodine/download/ | tar xJC /tmp \
 && mv /tmp/usr/bin/iodined /usr/bin/iodined \
 && patchelf --set-interpreter /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /usr/bin/iodined \
 && rm -rf /usr/bin/patchelf /tmp/* \
 && apk del --no-cache ca-certificates openssl libstdc++ patchelf\
 && chmod +x /start.sh

EXPOSE 53/udp

CMD ["/start.sh"]
