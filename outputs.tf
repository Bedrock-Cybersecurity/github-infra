output "protected_app_repos" {
  description = "App repos under branch protection (scanner gate, auto-merge, no required review)."
  value       = sort(keys(local.app_repos))
}

output "protected_infra_repos" {
  description = "Infra repos under branch protection (scanner gate + Rory review, no auto-merge)."
  value       = sort(keys(local.infra_repos))
}

output "required_status_check" {
  description = "The status check that must pass on every repo before merge."
  value       = local.scanner_check
}
