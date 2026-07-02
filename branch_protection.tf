# Branch protection for main across all Bedrock-Cybersecurity repos.
#
# Contract (identical core for every repo):
#   * Required status check "bedrock-scanner" must pass before merge (strict =
#     branch must be up to date with main first).
#   * No force pushes, no branch deletion.
#   * App repos: no required reviews — the Orchestrator owns risk classification.
#   * Infra repos: required Rory review + restrict_pushes (no direct pushes).
#
# Import blocks for pre-existing protections are in branch_protection_imports.tf.

resource "github_branch_protection" "app" {
  for_each = local.app_repos

  repository_id  = each.key
  pattern        = "main"
  enforce_admins = false # Rory can override a failed scanner check

  required_status_checks {
    strict   = true
    contexts = compact([local.scanner_check, lookup(local.coverage_checks, each.key, "")])
  }

  # Zero required approvals keeps auto-merge working — an empty restrict_pushes
  # allow list blocks the auto-merge bot from calling enablePullRequestAutoMerge.
  # Requiring a PR with 0 approvals enforces "no direct push" without blocking bot.
  required_pull_request_reviews {
    required_approving_review_count = 0
    dismiss_stale_reviews           = false
    require_code_owner_reviews      = false
  }

  allows_deletions    = false
  allows_force_pushes = false
}

resource "github_branch_protection" "infra" {
  for_each = local.infra_repos

  repository_id  = each.key
  pattern        = "main"
  enforce_admins = false

  required_status_checks {
    strict   = true
    contexts = [local.scanner_check]
  }

  required_pull_request_reviews {
    required_approving_review_count = 1
    require_code_owner_reviews      = true
    dismiss_stale_reviews           = true
  }

  restrict_pushes {
    push_allowances = []
  }

  allows_deletions    = false
  allows_force_pushes = false
}
