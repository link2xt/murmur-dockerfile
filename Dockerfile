FROM alpine:edge AS builder
ARG MUMBLE_VERSION=1.3.0
ARG SRC_URL=https://github.com/mumble-voip/mumble/releases/download/${MUMBLE_VERSION}/mumble-${MUMBLE_VERSION}.tar.gz

RUN apk add --no-cache \
avahi-dev \
boost-dev \
g++ \
libcap-dev \
make \
protobuf \
protobuf-dev \
qt5-qtbase-dev

RUN wget -O - ${SRC_URL} | tar xzv
WORKDIR /mumble-${MUMBLE_VERSION}
RUN qmake-qt5 -recursive main.pro CONFIG+="no-client no-ice" \
  && make

FROM alpine:edge
RUN adduser -s /sbin/nologin -DH murmur
RUN apk add --no-cache \
libprotobuf \
qt5-qtbase-sqlite \
libcap \
avahi-compat-libdns_sd

COPY --from=builder /mumble-1.3.0/release/murmurd /usr/bin/murmurd
RUN mkdir -pv /etc/mumrmur /var/lib/murmur
COPY murmur.ini /etc/murmur/murmur.ini
RUN chown -R murmur:murmur /etc/murmur /var/lib/murmur
EXPOSE 64738 64738/udp
USER murmur

VOLUME /etc/mumble
VOLUME /var/lib/murmur/

CMD ["/usr/bin/murmurd", "-fg", "-ini", "/etc/murmur/murmur.ini"]
