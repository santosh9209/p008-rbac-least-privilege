#!/usr/bin/env bash
# Edit the three emails, then run the other scripts from this folder in Azure Cloud Shell (Bash)
export SUB_ID="$(az account show --query id -o tsv)"
export LOCATION="centralindia"
export DEV_UPN="<developer-email>@kluniversity.in"
export OPS_UPN="<operations-email>@kluniversity.in"
export AUD_UPN="<auditor-email>@kluniversity.in"
export DEV_STORE="t008devstore1196"
export PROD_STORE="t008prodstore1196"

export DEV_ID=$(az ad user show --id "$DEV_UPN" --query id -o tsv)
export OPS_ID=$(az ad user show --id "$OPS_UPN" --query id -o tsv)
export AUD_ID=$(az ad user show --id "$AUD_UPN" --query id -o tsv)
export SUB_SCOPE="/subscriptions/$SUB_ID"
export DEV_SCOPE="$SUB_SCOPE/resourceGroups/rg-app-dev"
export PROD_SCOPE="$SUB_SCOPE/resourceGroups/rg-app-prod"
