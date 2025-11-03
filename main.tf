terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0" # ❌ Unpinned provider version (may cause breaking changes)
    }
  }
}

provider "google" {
  credentials = file("service-account.json") # ❌ Credentials hardcoded locally
  project     = "my-demo-project"
  region      = "us-central1"
}

resource "google_compute_instance" "example" {
  name         = "demo-instance" # ❌ Hardcoded name (not parameterized)
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network       = "default" # ⚠️ Uses default network (not secure)
    access_config {}          # ⚠️ Exposes public IP
  }
}
