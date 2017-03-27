FROM scratch
MAINTAINER Andrew Howden <hello@andrewhowden.com>

ADD https://storage.googleapis.com/kubernetes-release/release/v1.5.5/bin/linux/amd64/kubectl kubectl

ENTRYPOINT /kubectl
