output "instance_name" {
  description = "The name of the VM instance"
  value       = google_compute_instance.vm_example.name
}

output "public_ip" {
  description = "Public IP address of the VM"
  value       = google_compute_instance.vm_example.network_interface[0].access_config[0].nat_ip
}
