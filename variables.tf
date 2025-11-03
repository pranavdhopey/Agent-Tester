variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  default     = "us-central1"
}

variable "credentials_path" {
  description = "Path to the service account credentials file"
  type        = string
}
