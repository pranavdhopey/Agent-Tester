# `outputs.tf`
output "instance_name" {
  description = "Name of the created instance"
  value       = google_compute_instance.vm_instance.name
}

output "instance_ip" {
  description = "Public IP of the instance"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
