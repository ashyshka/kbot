#APP="kbot"
APP=$(shell basename $(shell git remote get-url origin))
REGISTRY="europe-central2-docker.pkg.dev/gl-devops-and-kubernetes/k3s-k3d"
#VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
VERSION=$(shell git rev-parse --short HEAD)

format:
        sed -i 's\1.21.4\1.20\g' go.mod
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

linux:  format get
	@printf "$GTarget OS/ARCH: $Rlinux/${TARGETARCH}$D\n"
	docker build --build-arg TARGETOS=linux --build-arg TARGETARCH=${TARGETARCH} --build-arg VERSION=${VERSION} -t ${REGISTRY}/${APP}:${VERSION}-linux-${TARGETARCH} .

windows:format get
	@printf "$GTarget OS/ARCH: $Rwindows/${TARGETARCH}$D\n"
	docker build --build-arg TARGETOS=windows --build-arg TARGETARCH=${TARGETARCH} --build-arg VERSION=${VERSION} -t ${REGISTRY}/${APP}:${VERSION}-windows-${TARGETARCH} .

darwin: format get
	@printf "$GTarget OS/ARCH: $Rdarwin/${TARGETARCH}$D\n"
	docker build --build-arg TARGETOS=darwin --build-arg TARGETARCH=${TARGETARCH} --build-arg VERSION=${VERSION} -t ${REGESTRY}/${APP}:${VERSION}-darwin-${TARGETARCH} .

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	@rm -rf kbot; \
	IMG=$$(docker images -q | head -n 1); \
	if [ -n "$${IMG}" ]; then  docker rmi -f $${IMG}; else printf "$RImage not found$D\n"; fi
