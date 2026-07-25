#!/usr/bin/env bash
set -euo pipefail

ENV_DIR="environments/dev"

if [[ ! -f "${ENV_DIR}/terraform.tfvars" ]]; then
  echo "Missing ${ENV_DIR}/terraform.tfvars."
  echo "Copy terraform.tfvars.example to terraform.tfvars and review it first."
  exit 1
fi

terraform -chdir="${ENV_DIR}" fmt -recursive
terraform -chdir="${ENV_DIR}" init
terraform -chdir="${ENV_DIR}" validate
terraform -chdir="${ENV_DIR}" plan -out=tfplan
terraform -chdir="${ENV_DIR}" apply tfplan
terraform -chdir="${ENV_DIR}" output
