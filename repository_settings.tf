# Repo-level merge settings. auto-merge and delete-branch-on-merge are NOT
# branch-protection attributes — they live on the repository itself. We import
# each existing repo and manage ONLY these two flags; every other repo attribute
# is left to the repo's own configuration via ignore_changes.
#
# Import blocks bring pre-existing repos into state on first apply. Review the
# plan carefully — if any attribute outside the two we manage shows a diff,
# add it to ignore_changes before applying.

import {
  for_each = local.all_repos
  to       = github_repository.managed[each.key]
  id       = each.key
}

resource "github_repository" "managed" {
  for_each = local.all_repos

  name       = each.key
  visibility = each.value

  # Infra repos never auto-merge — a human (Rory) must approve and merge.
  allow_auto_merge       = contains(keys(local.infra_repos), each.key) ? false : true
  delete_branch_on_merge = true

  lifecycle {
    ignore_changes = [
      description,
      homepage_url,
      topics,
      is_template,
      auto_init,
      gitignore_template,
      license_template,
      archived,
      archive_on_destroy,
      has_issues,
      has_projects,
      has_wiki,
      has_downloads,
      has_discussions,
      allow_merge_commit,
      allow_squash_merge,
      allow_rebase_merge,
      allow_update_branch,
      merge_commit_title,
      merge_commit_message,
      squash_merge_commit_title,
      squash_merge_commit_message,
      vulnerability_alerts,
      security_and_analysis,
      pages,
      template,
      web_commit_signoff_required,
    ]
  }
}
