#!/usr/bin/env bash
set -euo pipefail

echo "WARNING: This destroys the Northstar development network."
read -r -p "Type DESTROY-DEV to continue: " confirmation

if [[ "${confirmation}" != "DESTROY-DEV" ]]; then
  echo "Destroy cancelled."
  exit 1
fi

terraform -chdir="environments/dev" plan -destroy -out=destroy.tfplan
terraform -chdir="environments/dev" apply destroy.tfplan
