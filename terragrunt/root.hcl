locals {
    path_parts = split("/", path_relative_to_include())
    cloud = local.path_parts[0]
    environment = local.path_parts[1]
    region = local.path_parts[2]
}
# ─────────────────────────────────────────
# THING 1: Where does Terraform state live?
# ─────────────────────────────────────────
remote_state {
    backend = "gcs"
    config = {
        bucket = "shoshone-tfstate"
        prefix = path_relative_to_include()
        project = "shoshone-devops-platform"
    }
    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}
# Thing 2: Provider — which cloud are we talking to?
# generate writes a real .tf file to disk before terraform runs
generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
provider "google" {
    project = var.project_id
    region = var.region
}
EOF
}