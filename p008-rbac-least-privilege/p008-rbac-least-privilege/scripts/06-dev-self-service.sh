#!/usr/bin/env bash
# Phase 6: safe self-service - Developer may assign ONLY the Reader role on rg-app-dev
source ./00-variables.sh
READER_ID="acdd72a7-3385-48ef-bd42-f606fba81ae7"   # built-in Reader role definition ID
COND="((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {$READER_ID})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {$READER_ID}))"
az role assignment create --assignee-object-id "$DEV_ID" --assignee-principal-type User \
  --role "Role Based Access Control Administrator" --scope "$DEV_SCOPE" \
  --condition "$COND" --condition-version "2.0"
