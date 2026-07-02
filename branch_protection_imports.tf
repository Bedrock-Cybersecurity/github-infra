# Import pre-existing branch protections from GitHub into this Terraform state.
#
# All 13 app repos have an existing main protection rule managed by
# Cirius-Group-Inc/github-infra. These imports adopt them into this state so
# the apply reconciles to policy (correct check name, correct attrs) rather than
# failing with "Name already protected: main".
#
# bedrock-infra has existing protection (created by Cirius github-infra on first
# apply). Import it here too.
#
# github-infra (this repo) has NO existing main protection — it will be created
# fresh on first apply. No import needed for it.
#
# SEQUENCE: Apply this repo BEFORE removing bedrock resources from
# Cirius-Group-Inc/github-infra. Both states temporarily co-own the same
# GitHub resources; that is safe as long as both agree on current values (they
# will — the plan should be a no-op after import). Only after this apply is
# confirmed green should the Cirius cleanup PR be applied.

import {
  for_each = toset(keys(local.app_repos))
  to       = github_branch_protection.app[each.key]
  id       = "${each.key}:main"
}

import {
  to = github_branch_protection.infra["bedrock-infra"]
  id = "bedrock-infra:main"
}
