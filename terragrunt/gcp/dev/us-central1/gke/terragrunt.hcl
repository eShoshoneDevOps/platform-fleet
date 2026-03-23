include "root" {
    path = find_in_parent_folders("root.hcl")
    expose = true
}

terraform {
  source = "git::https://github.com/eShoshoneDevOps/platform-fleet//terraform/modules/gcp/gke?ref=main"
}

inputs = {
    # ID - who and where is this cluster
    project_id = "shoshone-devops-platoform"
    region = include.root.locals.region
    zones = ["us-central1-a", "us-central1-b"]

    # Name assembles itself from parent locals 
    # No hardcoding - cloud + environment + region 
    cluster_name = "${include.root.locals.cloud}-${include.root.locals.environment}-${include.root.locals.region}"

    # K8s version
    kubernetes_version = "1.35"
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
    network_name = "platform-dev"
    subnetwork_name = "platform-dev-us-central1"

    # IAM - Workload Identity for gcp
    enable_workload_identity = true
}