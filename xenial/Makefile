NAMESPACE ?= underscorgan
date := $(shell date +"%Y%m%d")

release: lint build publish docs

lint:
	@docker pull hadolint/hadolint:latest
	@docker run --rm -v $(PWD)/Dockerfile:/Dockerfile -i hadolint/hadolint hadolint --ignore DL3008 --ignore DL3018 --ignore DL3028 --ignore DL4000 --ignore DL4001 Dockerfile

build:
	@docker build -t $(NAMESPACE)/vanagon:xenial-$(date) .

publish:
	@docker push $(NAMESPACE)/vanagon:xenial-$(date)

docs:
	@docker run --rm \
		-v $(PWD)/README.md:/data/README.md \
		-e DOCKERHUB_USERNAME=$(NAMESPACE) \
		-e DOCKERHUB_PASSWORD="$(DOCKERHUB_PASSWORD)" \
	  -e DOCKERHUB_REPO_PREFIX=$(NAMESPACE) \
		-e DOCKERHUB_REPO_NAME=vanagon \
		sheogorath/readme-to-dockerhub

.PHONY: lint build publish docs
