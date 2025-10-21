# No provider version is pinned.
provider "google" {
  project = "my-prod-project-12345" # 1. Hardcoded project ID
  region  = "us-central1"
}

# 2. No remote backend is configured.
# State file will be saved locally, containing secrets.

# 3. Opening SSH to the entire internet.
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-from-world"
  network = "default"
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  source_ranges = ["0.0.0.0/0"] # <-- VERY BAD
}

resource "google_compute_instance" "web_server" {
  name         = "prod-web-vm"
  machine_type = "n1-standard-1" # 4. Hardcoded machine type
  zone         = "us-central1-a"
  
  # 5. No labels for billing or identification.

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  
  network_interface {
    network = "default"
    access_config {
      // Assigns an ephemeral public IP
    }
  }
  
  # 6. Hardcoding a secret directly in the configuration.
  metadata = {
    db_password = "MySuperSecretPassword123!"
  }
  
  # 7. Using the default compute service account (overly permissive).
  service_account {
    email  = "123456789-compute@developer.gserviceaccount.com" # Default SA
    scopes = ["cloud-platform"] # Full access to all GCP services
  }
}

# 8. Creating a publicly accessible storage bucket.
resource "google_storage_bucket" "public_assets" {
  name     = "my-company-public-assets-bucket"
  location = "US"
  
  # This binding makes every object in the bucket readable by anyone.
  iam_binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers", # <-- VERY BAD
    ]
  }
}

# 9. Creating and downloading a service account key.
resource "google_service_account" "my_app_sa" {
  account_id   = "my-app-sa"
  display_name = "My App Service Account"
}

resource "google_service_account_key" "my_app_key" {
  service_account_id = google_service_account.my_app_sa.name
}

# 10. Outputting a sensitive private key to the console.
output "service_account_private_key" {
  value = google_service_account_key.my_app_key.private_key
  # It is also NOT marked as 'sensitive'.
}
