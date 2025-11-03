terraform {
  # ❌ Local state backend (insecure for teams)
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0" # ❌ Loose version constraint
    }
  }
}

provider "google" {
  project = "gcp-lab-project"
  region  = "asia-south1"
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default" # ⚠️ Using default network

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"] # ❌ Open to the world
}

resource "google_compute_instance" "test_vm" {
  name         = "test-vm"
  machine_type = "e2-small"
  zone         = "asia-south1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network       = "default" # ⚠️ Default network again
    access_config {}          # ⚠️ Public IP
  }
}
