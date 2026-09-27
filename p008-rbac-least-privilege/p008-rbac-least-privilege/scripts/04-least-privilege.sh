#!/usr/bin/env bash
# Phase 4: remove Owner, assign scoped built-in roles
source ./00-variables.sh
for id in "$DEV_ID" "$OPS_ID" "$AUD_ID"; do
  az role assignment delete --assignee "$id" --role Owner --scope "$SUB_SCOPE"
done
az role assignment create --assignee-object-id "$DEV_ID" --assignee-principal-type User --role Contributor --scope "$DEV_SCOPE"
az role assignment create --assignee-object-id "$DEV_ID" --assignee-principal-type User --role Reader      --scope "$PROD_SCOPE"
az role assignment create --assignee-object-id "$AUD_ID" --assignee-principal-type User --role Reader      --scope "$SUB_SCOPE"
