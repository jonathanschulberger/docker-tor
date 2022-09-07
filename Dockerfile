FROM alpine:3.16.2 AS build

ARG TORVERSION=0.4.7

# pre-reqs
RUN apk add --no-cache \
    automake autoconf build-base git libevent-dev openssl-dev zlib-dev

# retrieve
RUN git clone -b release-$TORVERSION https://git.torproject.org/tor.git /tmp/src

# build
RUN cd /tmp/src && \
    ./autogen.sh && \
    ./configure --disable-unittests --disable-system-torrc --disable-html-manual --disable-asciidoc && \
    make -j$(nproc)


FROM alpine:3.16.2 AS tor-proxy

# pre-reqs
RUN apk add --no-cache \
    curl libevent openssl zlib

# create user to run tor
RUN adduser -S tor -D
USER tor

# pull build result from build stage
RUN mkdir -p ~/bin
COPY --from=build /tmp/src/src/app/tor /home/tor/bin

# final report
RUN /home/tor/bin/tor --version

HEALTHCHECK --timeout=10s --start-period=60s \
    CMD curl --fail --socks5-hostname 127.0.0.1:9050 -I -L 'https://ahmia.fi/' || exit 1

CMD [ "/home/tor/bin/tor" ]
