FROM scratch
MAINTAINER Andrew Howden <hello@andrewhowden.com>

COPY kubectl /
CMD ["/kubectl"]
