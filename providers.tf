# Define required provider version
terraform {
  required_version = ">= 1.0.0"

  # Use a remote backend for state management (e.g., Google Cloud Storage)
  backend "gcs" {
    bucket = "my-terraform-state-bucket"
    prefix = "terraform/state"
    credentials = "path/to/your-service-account-key.json"
  }
}

# GCP Provider Configuration
provider "google" {
  project = var.project_id
  region  = var.region
  credentials = file(var.credentials_path)
}
