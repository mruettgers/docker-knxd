FROM hypriot/rpi-alpine
MAINTAINER Michael Ruettgers <michael@ruettgers.eu>

ENV BUILD_PACKAGES  build-base \
                    gcc \
                    abuild \
                    binutils \
                    binutils-doc \
                    gcc-doc \
                    git \
                    libev-dev \
                    automake \
                    autoconf \
                    libtool \
                    argp-standalone \
                    linux-headers \
                    libusb-dev \
                    cmake \
                    cmake-doc \
                    dev86

#ENV PACKAGES 

RUN set -xe && \
    apk --no-cache update && \
    apk --no-cache add ${BUILD_PACKAGES} && \
    git clone https://github.com/knxd/knxd.git && \
    cd knxd && \
    ./bootstrap.sh && \
    ./configure --disable-systemd --enable-eibnetip --enable-eibnetserver --enable-eibnetiptunnel && \
    mkdir -p src/include/sys && ln -s /usr/lib/bcc/include/sys/cdefs.h src/include/sys && \
    make && \
    make install && \
    cd .. && rm -rf knxd && apk --no-cache --purge del ${BUILD_PACKAGES}

EXPOSE 3672 6720
VOLUME /etc/knxd
CMD ["knxd", "/etc/knxd/knxd.ini"]