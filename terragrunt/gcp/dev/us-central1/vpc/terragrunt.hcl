include "root" {
    path = find_in_parent_folders("root.hcl")
    expose = true
}

terraform {
    source = "git::https://github.com/eShoshoneDevOps/platform-fleet//terraform/modules/gcp/vpc?ref=main"
}

inputs = {
    project_id = "shoshone-devops-platform"
    region = include.root.locals.region

    # VPC name 
    network_name = "platform-${include.root.locals.environment}"

    # Subnet -regional in GCP = all zones 
    subnet_name = "platform-${include.root.locals.environment}-${include.root.locals.region}"
    subnet_cidr = "10.10.0.0/24"

    # secondary ranges -required by GKE 
    # pods and services need their own CIDR Blocks
    pods_cidr = "10.11.0.0/16"
    services_cidr = "10.12.0.0/16"

    # NAT - allows nodes to reach internet without public ip's
    enable_nat = true 

    # Firewall - default deny, allow only what's needed 
    firewall_rules = [
        {
            name = "allow-internal"
            direction = "INGRESS"
            ranges = ["10.10.0.0/24"]
            allow = [{
                protocol = "all"
            }]
        }
    ]

}