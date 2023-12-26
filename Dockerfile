ARG TARGETOS TARGETARCH VERSION

FROM quay.io/projectquay/golang:1.20 as builder

WORKDIR /go/src/app
COPY . .
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/ashyshka/kbot/cmd.appVersion=${VERSION}


FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./kbot", "start"]
