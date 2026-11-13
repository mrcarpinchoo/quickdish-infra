module "environment" {
  source = "../../modules/environment"

  account_id  = var.account_id
  environment = "prod"
}
