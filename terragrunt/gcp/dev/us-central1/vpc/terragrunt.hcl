locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env    = local.env_vars.locals
  region = local.region_vars.locals
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "git::https://github.com/eShoshoneDevOps/platform-modules.git//modules/gcp/vpc?ref=v0.1.0"
}

inputs = {
  project_id    = local.env.gcp_project_id
  region        = local.region.region
  vpc_name      = "vpc-${local.env.environment}-${local.region.region}"
  subnet_cidr   = local.region.subnet_cidr
  pod_cidr      = local.region.pod_cidr
  services_cidr = local.region.services_cidr
  labels        = local.env.common_labels
}
