.DEFAULT_GOAL := build
SHELL = /bin/bash -o pipefail

export TAG ?= $(shell git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo latest)
export REPO ?= jsmth/http-debug

IMAGE_TAG ?= $(REPO):$(TAG)

.PHONY: help build

help: ## display help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target> ...\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

build: login ## build dockerfile
	docker buildx create --name container --driver=docker-container || true
	docker buildx build --tag ${IMAGE_TAG} --tag $(REPO):latest --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --builder container --push .

login: ## Login
	docker login

include *.mk