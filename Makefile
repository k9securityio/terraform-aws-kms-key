.PHONY: clean deps init format lint converge verify destroy circleci-build kitchen docs shell

IMAGE_NAME := qualimente/terraform-infra-dev
IMAGE_TAG := 0.13.7

FQ_IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)

TERRAFORM_OPTS :=
terraform = @$(call execute,terraform $(1) $(TERRAFORM_OPTS))

terraform-docs = @$(call execute,terraform-docs $(1))

AWS_AUTH_VARS :=

ifdef AWS_PROFILE
	AWS_AUTH_VARS += $(AWS_AUTH_VARS) -e AWS_PROFILE=$(AWS_PROFILE)
endif

ifdef AWS_ACCESS_KEY_ID
	AWS_AUTH_VARS += $(AWS_AUTH_VARS) -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)
endif

ifdef AWS_SECRET_ACCESS_KEY
	AWS_AUTH_VARS += $(AWS_AUTH_VARS) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)
endif

ifdef AWS_SESSION_TOKEN
	AWS_AUTH_VARS += $(AWS_AUTH_VARS) -e AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN)
endif

AWS_OPTS := $(AWS_AUTH_VARS) -e AWS_REGION=$(AWS_REGION)

define execute
	if [ -z "$(CI)" ]; then \
		docker run --rm -it \
		    --platform linux/amd64 \
			$(AWS_OPTS) \
			-e USER=root \
			-v $(shell pwd):/module \
			-v $(HOME)/.aws:/root/.aws:ro \
			-v $(HOME)/.netrc:/root/.netrc:ro \
			$(FQ_IMAGE) \
			$(1); \
	else \
		echo $(1); \
		$(1); \
	fi;
endef

clean:
	rm -rf .terraform .kitchen terraform.tfstate.d test/fixtures/minimal/.terraform/ test/fixtures/minimal/generated/*

shell:
	@$(call execute,"/bin/bash",)

deps:
	@set -e
	@if test -z $(CI); then \
		docker pull $(FQ_IMAGE); \
	fi;

init:
	@echo "init: no-op while updating development workflow"

format:
	@echo "formatting code"
	@$(call terraform,fmt)

lint:
	@echo "linting code"
	@$(call terraform,get)

converge:
	@echo "converge: no-op while updating development workflow"

verify:
	@echo "verify: no-op while updating development workflow"

destroy:
	@echo "destroy: no-op while updating development workflow"

docs:
	$(call terraform-docs,markdown . > interface.md)
	$(call terraform-docs,markdown ./k9policy > k9policy/interface.md)
	# temporary: re-enable once testing is supported
	# @awk '{sub("139710491120","12345678910")}1' test/fixtures/minimal/generated/declarative_privilege_policy.json	> examples/generated.least_privilege_policy.json

all: deps init format converge verify docs

circleci-build:
	@circleci build \
	$(AWS_OPTS)
