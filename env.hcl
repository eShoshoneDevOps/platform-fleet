locals {
  environment    = "dev"
  gcp_project_id = "shoshone-devops-platform"
  cost_center    = "platform-engineering"
  team           = "platform"
  cluster_tier   = "dev"

  common_labels = {
    environment = "dev"
    team        = "platform"
    managed_by  = "terragrunt"
    repo        = "platform-fleet"   
    
  }
}