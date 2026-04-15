variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "github_owner" {
  description = "GitHub owner (user or org)"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "plasmid-purification-sop"
}

variable "allowed_email_domain" {
  description = "Email domain allowed to access the SOP"
  type        = string
  default     = "logomix.bio"
}
