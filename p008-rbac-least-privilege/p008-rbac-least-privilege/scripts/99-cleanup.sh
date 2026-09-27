#!/usr/bin/env bash
# Phase 8: delete everything (run ONLY after the final review)
source ./00-variables.sh
az group delete -n rg-app-dev  --yes --no-wait
az group delete -n rg-app-prod --yes --no-wait
az role definition delete --name "App Operator" --scope "$PROD_SCOPE"
