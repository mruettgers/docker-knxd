FROM arm32v6/alpine
MAINTAINER Michael Ruettgers <michael@ruettgers.eu>

ENV BUILD_PACKAGES \
  build-base \
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
  cmake-doc

ENV PACKAGES \
  dev86 \
  libusb \
  libev \
  libstdc++

RUN set -xe && \
  cd /tmp && \
  apk --no-cache add ${BUILD_PACKAGES} ${PACKAGES} && \
	git clone https://github.com/knxd/knxd.git && \
  cd knxd && \
  ./bootstrap.sh && \
  ./configure --disable-systemd --enable-eibnetip --enable-eibnetserver --enable-eibnetiptunnel && \
  mkdir -p src/include/sys && ln -s /usr/lib/bcc/include/sys/cdefs.h src/include/sys && \
  make V=1 && \
  make install && \
  cd .. && rm -rf knxd && apk --no-cache --purge del ${BUILD_PACKAGES}

EXPOSE 3672 6720
VOLUME /etc/knxd
CMD ["knxd", "/etc/knxd/knxd.ini"]
