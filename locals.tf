locals {
  # App repos: auto-merge allowed once the scanner gate passes, no required human
  # review (risk classification is the Orchestrator's job).
  # Value = repo visibility, matched to the live setting so import does not flip it.
  app_repos = {
    "bedrock-hub"           = "internal"
    "bedrock-soc"           = "private"
    "bedrock-grc"           = "private"
    "bedrock-scanner"       = "internal"
    "bedrock-attack"        = "internal"
    "bedrock-findings"      = "private"
    "bedrock-docs"          = "private"
    "bedrock-projects"      = "private"
    "bedrock-sdk"           = "private"
    "bedrock-ui"            = "private"
    "bedrock-infra-modules" = "private"
    "bedrock-mcp"           = "private"
    "bedrock-ndr"           = "private"
  }

  # Infra repos: same scanner gate + required Rory review, auto-merge disabled.
  infra_repos = {
    "bedrock-infra" = "private"
    "github-infra"  = "private"
    # "cloudflare-infra" = "private"  # uncomment once the repo exists
  }

  all_repos = merge(local.app_repos, local.infra_repos)

  # Per-repo required check in ADDITION to bedrock-scanner.
  # bedrock-scanner retains "Cirius scanner gate" (its own live-scanner self-test).
  # bedrock-ui retains the vitest coverage gate.
  coverage_checks = {
    "bedrock-scanner" = "Cirius scanner gate"
    "bedrock-ui"      = "vitest (80% coverage)"
  }

  # MUST match the check name the bedrock-scanner GitHub App posts exactly.
  # A mismatch makes the required check never resolve and PRs hang forever.
  scanner_check = "bedrock-scanner"
}
