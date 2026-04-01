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

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    network_self_link = "mock-network-self-link"
    subnet_self_link  = "mock-subnet-self-link"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

terraform {
  source = "git::https://github.com/eShoshoneDevOps/platform-modules.git//modules/gcp/gke?ref=v0.1.0"
}

inputs = {
  project_id   = local.env.gcp_project_id
  region       = local.region.region
  cluster_name = "gke-${local.env.environment}-${local.region.region}"
  zones        = local.region.zones

  network    = dependency.vpc.outputs.network_self_link
  subnetwork = dependency.vpc.outputs.subnet_self_link

  pod_cidr_name      = "pod-range"
  services_cidr_name = "services-range"

  node_pools = [
    {
      name         = "system"
      machine_type = "e2-standard-4"
      min_count    = 1
      max_count    = 3
      disk_size_gb = 100
      preemptible  = true
    }
  ]

  labels = local.env.common_labels
}
