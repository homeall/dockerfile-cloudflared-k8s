FROM golang:alpine as gobuild

RUN apk add --no-cache git gcc build-base; \
    go get -v github.com/cloudflare/cloudflared/cmd/cloudflared

WORKDIR /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared

RUN go build ./

FROM alpine

LABEL maintainer="HomeAll"

RUN adduser -S cloudflared; \
    apk add --no-cache ca-certificates bind-tools libcap; \
    rm -rf /var/cache/apk/*;

COPY --from=gobuild /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared/cloudflared /usr/local/bin/cloudflared

RUN setcap CAP_NET_BIND_SERVICE+eip /usr/local/bin/cloudflared

HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD nslookup -po=54 cloudflare.com 127.0.0.1 || exit 1

ADD https://raw.githubusercontent.com/homeall/dockerfile-cloudflared-k8s/main/config.yml /home/cloudflared/

RUN chown cloudflared /home/cloudflared/config.yml

USER cloudflared

CMD ["/bin/sh", "-c", "/usr/local/bin/cloudflared --config /home/cloudflared/config.yml --metrics 127.0.0.1:8080 --no-autoupdate --loglevel error"]
