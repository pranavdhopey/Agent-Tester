# `main.tf`
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-vm-instance"
  machine_type = "e2-medium"
  zone         = "${var.region}-a"
  tags         = ["terraform"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10-buster-v20210316"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "user:${file("~/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    prevent_destroy = true # Prevent accidental deletion
  }
}
