#
APP ?= $(shell basename $(shell git remote get-url origin) | cut -d"." -f1)

# Container Registry: DockerHub, Google Artifact Registry or GitHub Container Registry (DockerHub is default)
#REGISTRY ?= "ashyshka"
REGISTRY ?= "europe-central2-docker.pkg.dev/gl-devops-and-kubernetes/k3s-k3d"
#REGISTRY ?= "ghcr.io/ashyshka"

GITTAG := $(shell git describe --tags --abbrev=0)
ifeq ($(GITTAG),"")
  VERSION := $(shell git rev-parse --short HEAD)
else
  VERSION := $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
endif

TARGETOS ?= $(shell uname | tr '[:upper:]' '[:lower:]' 2> /dev/null)
TARGETARCH ?= $(shell dpkg --print-architecture 2>/dev/null)

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

info:
	@printf "$GTarget OS/ARCH/APP/VERSION: $R${TARGETOS}/${TARGETARCH}/${APP}/${VERSION}$D\n"

linux: info format get
	docker build --build-arg TARGETOS=linux --build-arg TARGETARCH=${TARGETARCH} --build-arg VERSION=${VERSION} -t ${REGISTRY}/${APP}:${VERSION}-linux-${TARGETARCH} .

windows: info format get
	docker build --build-arg TARGETOS=windows --build-arg TARGETARCH=${TARGETARCH} --build-arg VERSION=${VERSION} -t ${REGISTRY}/${APP}:${VERSION}-windows-${TARGETARCH} .

darwin: info format get
	docker build --build-arg TARGETOS=darwin --build-arg TARGETARCH=${TARGETARCH} --build-arg VERSION=${VERSION} -t ${REGESTRY}/${APP}:${VERSION}-darwin-${TARGETARCH} .

image: info format get
	docker build  --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH} --build-arg VERSION=${VERSION} -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} .

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	@rm -rf kbot; \
	IMG=$$(docker images -q | head -n 1); \
	if [ -n "$${IMG}" ]; then  docker rmi -f $${IMG}; else printf "$RImage not found$D\n"; fi
