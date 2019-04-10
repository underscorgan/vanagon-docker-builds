lint:
	@docker pull hadolint/hadolint:latest
	@docker run --rm -v $(PWD)/el7/Dockerfile:/Dockerfile -i hadolint/hadolint hadolint --ignore DL3008 --ignore DL3018 --ignore DL4000 --ignore DL4001 Dockerfile

.PHONY: lint
