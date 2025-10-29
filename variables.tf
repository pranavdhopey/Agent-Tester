# `variables.tf`
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  default     = "us-central1"
}

variable "credentials_path" {
  description = "Path to the GCP credentials JSON file"
  type        = string
}
