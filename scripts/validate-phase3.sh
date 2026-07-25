#!/usr/bin/env bash
set -euo pipefail

for env in dev prod; do
  echo "Validating ${env}..."
  terraform -chdir="environments/${env}" fmt -check -recursive
  terraform -chdir="environments/${env}" init -backend=false
  terraform -chdir="environments/${env}" validate
done

echo "Phase 3 static validation completed."
