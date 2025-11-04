# 1. Google Compute Engine Network (VPC)
resource "google_compute_network" "vpc_network" {
  name                    = "app-vpc-network"
  auto_create_subnetworks = false # Use custom subnetworks
}

# 2. Google Compute Engine Subnetwork
resource "google_compute_subnetwork" "app_subnet" {
  name          = "app-subnet-01"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
}

# 3. Google Compute Engine VM Instance
resource "google_compute_instance" "vm_instance" {
  name         = "web-server-vm"
  machine_type = var.machine_type
  zone         = "${var.region}-a" # Use a specific zone within the region

  # Define the boot disk using a public image
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Define the network interface
  network_interface {
    subnetwork = google_compute_subnetwork.app_subnet.self_link

    # Add an access config to assign an Ephemeral Public IP
    access_config {
      # Empty block assigns an Ephemeral External IP
    }
  }

  # Service account for the VM (optional, but recommended)
  service_account {
    scopes = ["cloud-platform"]
  }

  # Startup script to install Nginx
  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y nginx
    echo "<h1>Hello from Terraform on GCP!</h1>" | sudo tee /var/www/html/index.nginx-debian.html
  EOF
}
