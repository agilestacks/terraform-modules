.DEFAULT_GOAL := deploy

export TF_VAR_name 				?= dev
export AWS_PROFILE        ?= default
export AWS_DEFAULT_REGION ?= us-east-2
export TF_VAR_base_domain ?= stacks.delivery
export TF_LOG             ?= debug
export TF_LOG_PATH        ?= .terraform/$(TF_VAR_name).$(TF_VAR_base_domain).log
export TF_OPTS            ?= -no-color
export TF_UPDATE          ?= -update

export terraform          ?= terraform

export COMPONENT_NAME     ?= $(notdir $(abspath .))

deploy: init plan apply

init:
  @mkdir -p .terraform/$(TF_VAR_name).$(TF_VAR_base_domain)
  @rm -rf .terraform/$(TF_VAR_name).$(TF_VAR_base_domain)/*
  yes yes | $(terraform) init -get=true $(TF_CMD_OPTS) -force-copy  \
    -backend=true -input=false \
    -backend-config="bucket=$(TF_VAR_backend_bucket)" \
    -backend-config="region=$(TF_VAR_backend_region)" \
    -backend-config="key=$(COMPONENT_NAME)/$(TF_VAR_name).$(TF_VAR_base_domain)/terraform.tfstate" \
    -backend-config="profile=$(TF_VAR_aws_profile)" \
    . .terraform/$(TF_VAR_name).$(TF_VAR_base_domain)
.PHONY: init

get:
  @cd .terraform/$(TF_VAR_name).$(TF_VAR_base_domain) && \
    $(terraform) get $(TF_UPDATE)
.PHONY: get

plan:
  @cd .terraform/$(TF_VAR_name).$(TF_VAR_base_domain) && \
  $(terraform) plan $(TF_OPTS) -refresh=true -module-depth=-1 -out=terraform.tfplan
.PHONY: plan

apply:
  @cd .terraform/$(TF_VAR_name).$(TF_VAR_base_domain) && \
  $(terraform) apply $(TF_OPTS) -Xshadow=false terraform.tfplan
.PHONY: apply

undeploy: init
  @cd .terraform/$(TF_VAR_name).$(TF_VAR_base_domain) && \
  $(terraform) plan $(TF_OPTS) -destroy -refresh=true -module-depth=-1 -out=terraform.tfplan
  $(MAKE) apply
.PHONY: undeploy_this\