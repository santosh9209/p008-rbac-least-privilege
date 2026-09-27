#!/usr/bin/env bash
# Phase 2: resource groups + one storage account each (Standard, LRS)
source ./00-variables.sh
az group create -n rg-app-dev  -l "$LOCATION"
az group create -n rg-app-prod -l "$LOCATION"
az storage account create -n "$DEV_STORE"  -g rg-app-dev  -l "$LOCATION" --sku Standard_LRS
az storage account create -n "$PROD_STORE" -g rg-app-prod -l "$LOCATION" --sku Standard_LRS
