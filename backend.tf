terraform {
  # State in bedrock-platform account (863609217450). CI assumes github-deploy-main
  # (206820231356) which cross-account assumes into 863609217450 for state access.
  # S3-native locking (use_lockfile, Terraform >= 1.10) — no DynamoDB dependency.
  backend "s3" {
    bucket       = "bedrock-platform-terraform"
    key          = "github-infra/terraform.tfstate"
    region       = "us-west-2"
    use_lockfile = true
    encrypt      = true
  }
}
