output "d1_database_name" {
  description = "D1 database name (database_name in wrangler.jsonc)."
  value       = cloudflare_d1_database.this.name
}

output "d1_database_id" {
  description = "D1 database id (database_id in wrangler.jsonc)."
  value       = cloudflare_d1_database.this.id
}

output "pages_project_name" {
  description = "Pages project the frontend pipeline deploys to."
  value       = cloudflare_pages_project.frontend.name
}

output "pages_url" {
  description = "Public URL of the frontend. Add it to CORS_ORIGINS in wrangler.jsonc."
  value       = "https://${cloudflare_pages_project.frontend.subdomain}"
}
