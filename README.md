# quickdish-infra

Terraform for the Cloudflare resources of [QuickDish](https://github.com/mrcarpinchoo/iteso-devops-restaurant-ordering-system), a restaurant ordering platform.

## What it creates

Each environment (Dev and Prod) gets the same resources, defined once in `modules/environment`:

| Resource             | Dev                      | Prod                      | Used by                                                 |
| -------------------- | ------------------------ | ------------------------- | ------------------------------------------------------- |
| D1 database          | `quickdish-dev`          | `quickdish-prod`          | `quickdish-api` (Cloudflare Workers)                    |
| Pages project        | `quickdish-frontend-dev` | `quickdish-frontend-prod` | `quickdish-frontend`, deployed by its pipeline           |

Not managed here: the Workers (deployed by the `quickdish-api` pipeline with `wrangler deploy`), the database tables (SQL migrations in `quickdish-api`), the site files (uploaded by the `quickdish-frontend` pipeline) and secrets such as `JWT_SECRET`.

## Layout

```
modules/environment/   # the resources of one environment
environments/dev/      # calls the module with environment = "dev"
environments/prod/     # calls the module with environment = "prod"
```

Each environment folder has its own state, so Dev can be changed and checked before Prod.

## Requirements

- Terraform 1.9 or later. The team runs it with the `hashicorp/terraform` Docker image.
- A Cloudflare API token with **D1: Edit** and **Cloudflare Pages: Edit** permissions, in the `CLOUDFLARE_API_TOKEN` environment variable. Never put it in a file in this repo.

The account id is in each `terraform.tfvars`. It isn't a secret.

## Usage

Run every command from the environment's folder, Dev first:

```bash
cd environments/dev
terraform init
terraform plan     # review what will change
terraform apply
terraform output   # values to copy into quickdish-api
```

With Docker, mount the repo and pass the token through:

```bash
docker run --rm -it \
  -e CLOUDFLARE_API_TOKEN \
  -v "$PWD:/workspace" -w /workspace/environments/dev \
  hashicorp/terraform:latest plan
```

## Outputs

| Output               | Where it goes                                                  |
| -------------------- | -------------------------------------------------------------- |
| `d1_database_name`   | `database_name` of the environment in `quickdish-api/wrangler.jsonc` |
| `d1_database_id`     | `database_id` of the environment in `quickdish-api/wrangler.jsonc`   |
| `pages_project_name` | The project the `quickdish-frontend` pipeline deploys to       |
| `pages_url`          | `CORS_ORIGINS` of the environment in `quickdish-api/wrangler.jsonc`  |

## State

State is kept **locally**, in `terraform.tfstate` inside each environment folder. It is git-ignored and must never be committed.

- Only the person who holds the state files can run `plan` and `apply`.
- Keep a backup of both `terraform.tfstate` files outside the repo. If they are lost, Terraform no longer knows about the resources, and they have to be imported again with `terraform import`.

## Committing

Commit `.terraform.lock.hcl` in each environment folder: it pins the Cloudflare provider version. It lists hashes for `linux_amd64` and `linux_arm64`. After a provider upgrade, regenerate it with:

```bash
terraform providers lock -platform=linux_amd64 -platform=linux_arm64
```
