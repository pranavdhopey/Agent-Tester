terraform {
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

resource "google_compute_instance" "vm_example" {
  name         = "simple-gce-vm"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {} # adds ephemeral public IP
  }

  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      apt-get update -y
      apt-get install -y nginx
      echo "Hello from Terraform GCE VM!" > /var/www/html/index.html
      systemctl enable nginx
      systemctl start nginx
    EOT
  }

  tags = ["terraform", "demo"]
}
