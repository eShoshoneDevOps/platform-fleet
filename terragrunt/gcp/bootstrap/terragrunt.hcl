locals {
    env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    env = local.env_vars.locals
}

include "root" {
    path = find_in_parent_folders("root.hcl")
    expose = true 
}

terraform {
  source = "git::https://github.com/eShoshoneDevOps/platform-modules.git//modules/gcp/iam/workload-identity?ref=v0.2.2"
}

inputs = {
  project_id  = local.env.gcp_project_id
  github_org  = "eShoshoneDevOps"
  github_repo = "platform-fleet"
}