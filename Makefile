OWNER = nicbet
IMAGE = phoenix
TAG = $(OWNER)/$(IMAGE)
VERSION = 1.7.12

all: docker-image test

.DEFAULT: all
.PHONY: mrproper latest pull image-scan test

# Build the docker image
docker-image: Dockerfile
	$(info Building image with tag $(TAG):$(VERSION))
	@docker build --no-cache -t $(TAG):$(VERSION) .

# Fetch the image from docker.io (requires `docker login` for private repositories)
pull:
	$(info Pulling image with tag $(TAG):$(VERSION))
	@docker pull $(TAG):$(VERSION)

# Tag current version as latest
latest:
	$(info Tagging $(TAG):$(VERSION) as $(TAG):latest)
	@docker tag $(TAG):$(VERSION) $(TAG):latest

# Delete all images for $(tag)
mrproper: clean
	$(info Removing images for tag $(TAG):$(VERSION) and pruning related images.)
	-docker rmi $(TAG):$(VERSION) >/dev/null 2>&1
	-docker rmi $(shell docker images -a --filter=dangling=true -q) >/dev/null 2>&1

image-scan:
	$(info Scanning docker image for vulnerabilities with trivy ...)
	@trivy image $(TAG):$(VERSION)

test: image-scan
