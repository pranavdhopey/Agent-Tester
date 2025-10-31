variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Deployment region"
  default     = "us-central1"
}

variable "credentials_path" {
  description = "Path to service account JSON file"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "machine_type" {
  description = "Compute Engine instance type"
  type        = string
  default     = "e2-medium"
}

variable "service_account_email" {
  description = "Service account email used by the VM"
  type        = string
}
