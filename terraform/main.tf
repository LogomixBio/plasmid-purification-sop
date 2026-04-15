terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# --- Pages Project (GitHub integration) ---
resource "cloudflare_pages_project" "sop" {
  account_id        = var.cloudflare_account_id
  name              = "plasmid-dapi-sop"
  production_branch = "main"

  source = {
    type = "github"
    config = {
      owner                         = var.github_owner
      repo_name                     = var.github_repo
      production_branch             = "main"
      deployments_enabled           = true
      production_deployment_enabled = true
    }
  }

  build_config = {
    # Static HTML — no build command needed
    build_command   = ""
    destination_dir = "."
  }
}

# --- Access Application (protect the Pages URL) ---
resource "cloudflare_zero_trust_access_application" "sop" {
  account_id                 = var.cloudflare_account_id
  name                       = "DAPI Plasmid Concentration SOP"
  domain                     = "${cloudflare_pages_project.sop.name}.pages.dev"
  type                       = "self_hosted"
  session_duration           = "720h"
  auto_redirect_to_identity  = true

  policies = [
    {
      name     = "Allow logomix.bio domain"
      decision = "allow"
      include = [
        {
          email_domain = {
            domain = var.allowed_email_domain
          }
        }
      ]
    }
  ]
}
