# github-infra

Terraform configuration for Bedrock Cybersecurity GitHub organization infrastructure.

## Contents

- `branch_protection.tf` - Branch protection rules for all Bedrock repositories

## Branch Protection Rules

### Standard Repositories

All standard Bedrock repositories require:
- "Bedrock Scanner" status check must pass
- Auto-merge enabled
- Branch deleted after merge
- Direct pushes to main restricted

### Infrastructure Repositories

Infrastructure repositories (`bedrock-infra`, `cloudflare-infra`, `github-infra`) require:
- All standard rules above
- At least 1 approving review (Rory must review)
- Stale reviews dismissed on new commits

## Usage

```bash
# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes (Rory only)
terraform apply
```

## Authentication

Set `GITHUB_TOKEN` environment variable with a token that has `admin:org` and `repo` scopes.

```bash
export GITHUB_TOKEN="ghp_..."
terraform plan
```
