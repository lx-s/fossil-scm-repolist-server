FROM alpine:3.12

ENV USERNAME=fossil \
    FOSSIL_VERSION=2.11.1

RUN addgroup -Sg 400 $USERNAME \
  && adduser -Su 400 -G $USERNAME $USERNAME \
  && mkdir /fossils \
  && chown -R $USERNAME:$USERNAME /fossils \
  && apk add --no-cache \
        curl gcc make tcl \
        musl-dev \
        openssl-dev zlib-dev \
        openssl-libs-static zlib-static \
  && mkdir -p /tmp/fossil-build \
  && curl https://www.fossil-scm.org/index.html/tarball/fossil-src.tar.gz?name=fossil-src&r=version-$FOSSIL_VERSION \
     -o /tmp/fossil-src.tar.gz \
  && tar xf /tmp/fossil-src.tar.gz \
  && cd /tmp/fossil-src/ \
  && ./configure \
         --static \
         --disable-fusefs \
         --with-th1-docs \
         --with-th1-hooks \
  && make \
  && cp fossil /usr/bin/local/ \
  && cd / \
  && rm /tmp/fossil-src.tar.gz \
  && rm -rf /tmp/fossil-src \
  && apk del --purge --no-cache \
      curl gcc make tcl \
        musl-dev \
        openssl-dev zlib-dev \
        openssl-libs-static zlib-static \
  && rm -f /var/cache/apk/*

VOLUME ["/fossils"]

WORKDIR "/fossils"

EXPOSE 8181

ENTRYPOINT ["/usr/local/bin/fossil"]

CMD ["server","--repolist","--port","8181","--skin","ardoise","/fossils"]
