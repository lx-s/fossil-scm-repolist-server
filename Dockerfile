FROM alpine:3.16.0

ENV USERNAME=fossil

RUN addgroup -Sg 400 g$USERNAME \
  && adduser -Su 400 -G g$USERNAME $USERNAME \
  && apk update \
  && apk upgrade \
  && apk add fossil

VOLUME ["/fossils"]

WORKDIR "/fossils"

EXPOSE 8181

ENTRYPOINT ["/usr/local/bin/fossil"]

CMD ["server","--repolist","--port","8181","--skin","ardoise","/fossils"]
