# Single provider — this repo governs Bedrock-Cybersecurity only.
#
# Token is an org-admin GitHub App installation token or fine-grained PAT with
# Administration: read+write on every repo in this org. Supplied via GITHUB_TOKEN
# env var, loaded from AWS Secrets Manager in CI (see deploy.yml).
provider "github" {
  owner = "Bedrock-Cybersecurity"
}
