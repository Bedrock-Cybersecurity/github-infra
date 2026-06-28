# Standard branch protection for all Bedrock repositories
# Requires "Bedrock Scanner" status check to pass before merging to main

locals {
  # Standard repositories - Bedrock Scanner check only
  standard_repos = toset([
    "bedrock-hub",
    "bedrock-soc",
    "bedrock-grc",
    "bedrock-scanner",
    "bedrock-attack",
    "bedrock-findings",
    "bedrock-docs",
    "bedrock-projects",
    "bedrock-sdk",
    "bedrock-ui",
    "bedrock-infra-modules",
  ])

  # Infrastructure repositories - require PR review from Rory
  infra_repos = toset([
    "bedrock-infra",
    "cloudflare-infra",
    "github-infra",
  ])
}

resource "github_branch_protection" "standard_repos" {
  for_each = local.standard_repos

  repository_id = each.value
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["Bedrock Scanner"]
  }

  allow_auto_merge       = true
  delete_branch_on_merge = true

  restrict_pushes {
    push_allowances = []
  }
}

resource "github_branch_protection" "infra_repos" {
  for_each = local.infra_repos

  repository_id = each.value
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["Bedrock Scanner"]
  }

  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews           = true
  }

  allow_auto_merge       = true
  delete_branch_on_merge = true

  restrict_pushes {
    push_allowances = []
  }
}
