# Task runner

.PHONY: help build

.DEFAULT_GOAL := help

SHELL := /bin/bash

APP_VERSION := $(shell git describe --abbrev=0)
GIT_HASH     := $(shell git rev-parse --short HEAD)

ANSI_TITLE        := '\e[1;32m'
ANSI_CMD          := '\e[0;32m'
ANSI_TITLE        := '\e[0;33m'
ANSI_SUBTITLE     := '\e[0;37m'
ANSI_WARNING      := '\e[1;31m'
ANSI_OFF          := '\e[0m'

PATH_DOCS                := $(shell pwd)/docs
PATH_BUILD_CONFIGURATION := $(shell pwd)/build

TIMESTAMP := $(shell date "+%s")

help: ## Show this menu
	@echo -e $(ANSI_TITLE)kubectl$(ANSI_OFF)$(ANSI_SUBTITLE)" - Builds a dockerfile with kubectl"$(ANSI_OFF)
	@echo -e $(ANSI_TITLE)Commands:$(ANSI_OFF)
	@grep -E '^[a-zA-Z_-%]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "    \033[32m%-30s\033[0m %s\n", $$1, $$2}'

clean: ## Remove any build artifacts
	-rm kubectl

fetch: clean ## ${VERSION} | Downloads the kubectl binary
	[ ! -z "${VERSION}" ] || exit 1
	curl --remote-name \
	    --silent \
	    "https://storage.googleapis.com/kubernetes-release/release/v${VERSION}/bin/linux/amd64/kubectl"
	chmod +x kubectl

image: ## Builds and tags an image at a given version. Expects VCS to be tagged with the appropriate version (Debian versioning strategy)
	[ ! -z "$(APP_VERSION)" ] || exit 1
	docker build -t quay.io/littlemanco/kubectl:v$(APP_VERSION) .

push: ## ${BUILD_VERSION} | Pushes an image at a given tag to upstream
	docker push quay.io/littlemanco/kubectl:v$(APP_VERSION)

all: clean fetch image push ## ${VERSION}, ${BUILD_VERSION} | Fetches, builds and pushes an image
	echo "Done."
