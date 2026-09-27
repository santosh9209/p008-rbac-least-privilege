#!/usr/bin/env bash
# Phase 3: audit all role assignments, including inherited ones
source ./00-variables.sh
OUT=${1:-audit.tsv}
az role assignment list --all --include-inherited \
  --query "[].{principal:principalName, role:roleDefinitionName, scope:scope}" -o tsv > "$OUT"
echo "Saved $OUT"
echo "--- rg-app-prod (including inherited) ---"
az role assignment list --resource-group rg-app-prod --include-inherited \
  --query "[].{principal:principalName, role:roleDefinitionName, scope:scope}" -o table
