NAMESPACE ?= underscorgan

lint:
	@docker pull hadolint/hadolint:latest
	@docker run --rm -v $(PWD)/el7/Dockerfile:/Dockerfile -i hadolint/hadolint hadolint --ignore DL3008 --ignore DL3018 --ignore DL4000 --ignore DL4001 Dockerfile

build:
	@docker build -t $(NAMESPACE)/vanagon:el7 el7

publish:
	@docker push $(NAMESPACE)/vanagon:el7

docs:
	@docker run --rm \
		-v $(PWD)/README.md:/data/README.md \
		-e DOCKERHUB_USERNAME=$(NAMESPACE) \
		-e DOCKERHUB_PASSWORD="$(DOCKERHUB_PASSWORD)" \
	  -e DOCKERHUB_REPO_PREFIX=$(NAMESPACE) \
		-e DOCKERHUB_REPO_NAME=vanagon \
		sheogorath/readme-to-dockerhub

.PHONY: lint build publish docs
