output "d1_database_name" {
  description = "D1 database name (database_name in wrangler.jsonc)."
  value       = module.environment.d1_database_name
}

output "d1_database_id" {
  description = "D1 database id (database_id in wrangler.jsonc)."
  value       = module.environment.d1_database_id
}

output "pages_project_name" {
  description = "Pages project the frontend pipeline deploys to."
  value       = module.environment.pages_project_name
}

output "pages_url" {
  description = "Public URL of the frontend. Add it to CORS_ORIGINS in wrangler.jsonc."
  value       = module.environment.pages_url
}
