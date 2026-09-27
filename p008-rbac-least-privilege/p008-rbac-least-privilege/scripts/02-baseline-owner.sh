#!/usr/bin/env bash
# Phase 2: INSECURE baseline - everyone is Owner at subscription scope (demonstration only)
source ./00-variables.sh
for id in "$DEV_ID" "$OPS_ID" "$AUD_ID"; do
  az role assignment create --assignee-object-id "$id" --assignee-principal-type User \
    --role Owner --scope "$SUB_SCOPE"
done
