FROM golang:1.16-buster AS builder

WORKDIR /workdir

COPY ./ ./

RUN go get .
RUN GOOS=linux GOARCH=amd64 go build -o main

FROM alpine:3.11.2 
RUN apk add --no-cache ca-certificates libc6-compat
COPY --from=builder /workdir/main /usr/local/bin/server
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
RUN chmod +x /usr/local/bin/server

EXPOSE 9090
EXPOSE 9091

ENTRYPOINT [ "/usr/local/bin/server" ]
