# Everything one QuickDish environment needs on Cloudflare.
# The Workers, the database tables and the site files are not created here:
# the app pipelines deploy them with wrangler.

terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

# Database for the API. Its id goes into quickdish-api/wrangler.jsonc.
resource "cloudflare_d1_database" "this" {
  account_id = var.account_id
  name       = "quickdish-${var.environment}"
}

# Hosting for the frontend. The pipeline uploads each build to this project
# (Direct Upload), so it isn't connected to the GitHub repo.
resource "cloudflare_pages_project" "frontend" {
  account_id        = var.account_id
  name              = "quickdish-frontend-${var.environment}"
  production_branch = var.production_branch
}
