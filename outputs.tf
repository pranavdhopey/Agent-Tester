output "instance_name" {
  description = "The name of the created instance"
  value       = google_compute_instance.vm_instance.name
}

output "instance_ip" {
  description = "Public IP address of the VM"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "vpc_name" {
  description = "VPC created for the environment"
  value       = google_compute_network.vpc.name
}
