#!/usr/bin/env bash
# Phase 5: custom "App Operator" role for Operations (Bottleneck 1)
source ./00-variables.sh
sed "s/<SUBSCRIPTION_ID>/$SUB_ID/" ../custom-roles/app-operator.json > /tmp/app-operator.json
az role definition create --role-definition @/tmp/app-operator.json
echo "Waiting for the role to replicate..."; sleep 60
az role assignment create --assignee-object-id "$OPS_ID" --assignee-principal-type User --role "App Operator" --scope "$PROD_SCOPE"
