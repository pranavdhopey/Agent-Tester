terraform {
  required_version = ">= 1.6.0"

  backend "gcs" {
    bucket      = "my-terraform-state-bucket"
    prefix      = "projects/sample-gce/state"
    credentials = "path/to/service-account.json"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_path)
}

# Use locals for standardization
locals {
  environment = var.environment
  instance_name = "vm-${var.environment}-01"
  labels = {
    environment = var.environment
    owner       = "devops-team"
    managed_by  = "terraform"
  }
}

# Dynamic data source for latest Debian image
data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

# Network setup (best practice: separate network resource)
resource "google_compute_network" "vpc" {
  name                    = "vpc-${var.environment}"
  auto_create_subnetworks = false
  description             = "Custom VPC for ${var.environment}"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-${var.environment}"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Compute Instance
resource "google_compute_instance" "vm_instance" {
  name         = local.instance_name
  machine_type = var.machine_type
  zone         = "${var.region}-a"
  tags         = ["web", local.environment]
  labels       = local.labels

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
      size  = 20
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {} # ephemeral public IP
  }

  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      apt-get update -y && apt-get install -y nginx
      systemctl enable nginx && systemctl start nginx
      echo "Welcome to ${local.environment}" > /var/www/html/index.html
    EOT
  }

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  lifecycle {
    prevent_destroy = true
  }
}
