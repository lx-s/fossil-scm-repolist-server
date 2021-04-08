FROM alpine:3.11.7

ENV USERNAME=fossil \
    FOSSIL_VERSION=2.15.1

RUN addgroup -Sg 400 g$USERNAME \
  && adduser -Su 400 -G g$USERNAME $USERNAME \
  && apk add --no-cache gcc make tcl musl-dev openssl-dev zlib-dev openssl-libs-static zlib-static fossil \
  && mkdir -p /usr/local/src/fossils/fossil/build \
  && cd /usr/local/src/fossils \
  && fossil clone https://www.fossil-scm.org/home fossil.fossil --user $USERNAME \
  && cd fossil \
  && fossil open ../fossil.fossil \
  && fossil checkout --force version-$FOSSIL_VERSION \
  && cd build \
  && ../configure --static --disable-fusefs \
  && make \
  && make install \
  && cd /tmp \
  && rm -rf /usr/local/src \
  && apk del --purge --no-cache fossil gcc make tcl musl-dev openssl-dev zlib-dev openssl-libs-static zlib-static fossil \
  && rm -f /var/cache/apk/*

VOLUME ["/fossils"]

WORKDIR "/fossils"

EXPOSE 8181

ENTRYPOINT ["/usr/local/bin/fossil"]

CMD ["server","--repolist","--port","8181","--skin","ardoise","/fossils"]
