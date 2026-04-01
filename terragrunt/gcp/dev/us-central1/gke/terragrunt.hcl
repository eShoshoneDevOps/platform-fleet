include "root" {
    path = find_in_parent_folders("root.hcl")
    expose = true
}

dependency "vpc" {
    config_path = "../vpc"

    mock_outputs = {
        network_name = "mock-network"
        subnetwork_name = "mock-subnet"
    }
    mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
    # ID - who and where is this clusterlocals {
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

    project_id = "shoshone-devops-platform"
    region = include.root.locals.region
    zones = ["us-central1-a", "us-central1-b"]

    # Name assembles itself from parent locals 
    # No hardcoding - cloud + environment + region 
    cluster_name = "${include.root.locals.cloud}-${include.root.locals.environment}-${include.root.locals.region}"

    # K8s version
    # kubernetes_version = "1.35"
    release_channel = "REGULAR"

    # Node pool
    node_pools = [
        {
            name = "platform"
            machine_type = "e2-standard-4"
            min_count = 1
            max_count = 5
            disk_size_gb = 100
        }
    ]

    # Networking - will come from VPC dependency
    network_name = dependency.vpc.outputs.network_name
    subnetwork_name = dependency.vpc.outputs.subnetwork_name

    # IAM - Workload Identity for gcp
    enable_workload_identity = true
}
