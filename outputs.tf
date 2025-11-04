output "vm_external_ip" {
  description = "The external IP address of the VM instance"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "vpc_network_name" {
  description = "The name of the created VPC network"
  value       = google_compute_network.vpc_network.name
}
