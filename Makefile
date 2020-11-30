DOCKER_IMAGE_NAME ?= anderson4u2/k8s-webhook-cert-manager
DOCKER_IMAGE_TAG ?= 0.0.2
KUBECTL_VERSION ?= v1.18.12


.PHONY: all
all: build

.PHONY: build
build: lint build-container

.PHONY: build-container
build-container:
	docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

.PHONY: build-container-e2e
build-container-e2e:
	docker build --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) . 

.PHONY: push-container
push-container:
	docker push $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) 

.PHONY: check-shellcheck
check-shellcheck:
	@type shellcheck >/dev/null 2>&1 || (echo "You don't have shellcheck. Please install it: https://github.com/koalaman/shellcheck#installing" && exit 1)

.PHONY: lint
lint: check-shellcheck
	@echo "[lint] Validating code using shellcheck"
	@shellcheck generate_certificate.sh

.PHONY: e2e-test
e2e-test:
	@echo "[test] Running e2e tests"
	./e2e-tests/tests.sh
