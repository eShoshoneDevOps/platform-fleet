locals {
  region        = "us-central1"
  zones         = ["us-central1-b", "us-central1-c", "us-central1-f"]
  subnet_cidr   = "10.10.0.0/20"
  pod_cidr      = "10.11.0.0/16"
  services_cidr = "10.12.0.0/20"
}