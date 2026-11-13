variable "account_id" {
  description = "Cloudflare account id."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{32}$", var.account_id))
    error_message = "account_id must be a 32-character hexadecimal Cloudflare account id."
  }
}

variable "environment" {
  description = "Environment name. Used as a suffix in every resource name."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be \"dev\" or \"prod\"."
  }
}

variable "production_branch" {
  description = "Branch whose deployments Pages treats as production."
  type        = string
  default     = "main"
}
