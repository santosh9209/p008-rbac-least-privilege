# Role-Based Access Control Redesign for Least Privilege

**Project ID:** 24CC3046-P008 · **Domain:** Identity & Access · **Platform:** Microsoft Azure
**Team:** T008 · K L University

## Problem

All team members held **Owner** on the Azure subscription. Anyone could delete production resources or grant access to anyone else. This project replaces that setup with least-privilege access: every identity gets only the permissions its job needs, at the smallest possible scope.

| Use case | Bottleneck addressed |
|---|---|
| Replace Owner assignments with scoped built-in roles | Inherited assignments at subscription scope are overlooked |
| Enable safe self-service for developers | Built-in roles do not match the needed permission set |

## Environment

| Item | Value |
|---|---|
| Subscription | Azure for Students |
| Tenant | K L University (kluniversity.in) |
| Region | Central India |
| Resource groups | `rg-app-dev`, `rg-app-prod` |
| Resources | One Standard/LRS storage account in each group |

The university tenant does not allow students to create users or groups, so existing team member accounts were used as test identities and roles were assigned to users directly. In production, roles should be assigned to security groups.

## Final Role Design

| Member | Project role | Role | Scope |
|---|---|---|---|
| Admin | Administrator | Owner | Subscription |
| Developer | Developer | Contributor | `rg-app-dev` |
| Developer | Developer | Reader | `rg-app-prod` |
| Developer | Developer | Role Based Access Control Administrator (condition: may assign **Reader only**) | `rg-app-dev` |
| Operations | Operations | **App Operator** (custom) | `rg-app-prod` |
| Auditor | Auditor | Reader | Subscription |

**Result:** privileged role assignments reduced from **5 to 2** (the admin's Owner and a tenant-root User Access Administrator inherited from the university, which is outside the subscription owner's control).

## Custom Role: App Operator

Operations must create containers in production without being able to delete resources or read keys.

- **Reader** is too weak (cannot create containers).
- **Storage Account Contributor** is too strong (can delete the account and list keys).

Definition: [`custom-roles/app-operator.json`](custom-roles/app-operator.json)

Deliberately excluded:
- `storageAccounts/delete`, so resources can't be deleted
- `storageAccounts/listKeys/action`, since keys give full data access and bypass RBAC
- `storageAccounts/write`, so no new storage accounts can be created

## Audit Findings

| # | Finding |
|---|---|
| F1 | All users held Owner at subscription scope |
| F2 | Owner was granted with unrestricted delegation (could assign any role) |
| F3 | Subscription-level Owner was inherited into every resource group, including production |
| F4 | Inherited assignments cannot be removed at the resource group level, only at their source scope |
| F5 | A tenant-root User Access Administrator is inherited into the subscription |

## Verification

| User | Action | Result |
|---|---|---|
| Developer | Create container in dev | ✅ Allowed |
| Developer | Create container / delete in prod | ❌ Denied |
| Developer | Assign Reader on dev | ✅ Allowed |
| Developer | Assign Contributor/Owner on dev | ❌ Denied by condition |
| Operations | Create container in prod | ✅ Allowed |
| Operations | Delete storage account / view access keys | ❌ Denied |
| Auditor | View all resources | ✅ Allowed |
| Auditor | Create, modify or delete anything | ❌ Denied |

## Repository Structure

```
custom-roles/   App Operator role definition (JSON)
scripts/        Azure CLI scripts for each phase
screenshots/    Portal evidence (before / after / tests)
docs/           Project report
audit/          Role assignment exports (CSV files are git-ignored)
```

## Scripts

The project was implemented in the Azure Portal. The scripts in `scripts/` are the equivalent Azure CLI commands, so the setup can be reproduced.

1. Open Azure Cloud Shell (Bash) and upload the repository.
2. Edit the three emails in `scripts/00-variables.sh`.
3. Run from inside `scripts/`, in order:

| Script | Phase |
|---|---|
| `01-setup-resources.sh` | Resource groups and storage accounts |
| `02-baseline-owner.sh` | Insecure baseline (everyone Owner), for demonstration only |
| `03-audit.sh` | Audit including inherited assignments |
| `04-least-privilege.sh` | Remove Owner, assign scoped built-in roles |
| `05-custom-role.sh` | Create and assign App Operator |
| `06-dev-self-service.sh` | Conditional RBAC Administrator for Developer |
| `99-cleanup.sh` | Delete all resources after evaluation |
