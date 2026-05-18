output "manager_public_ip" {
  description = "Public IP of the swarm manager"
  value       = aws_instance.manager.public_ip
}

output "manager_private_ip" {
  description = "Private IP of the swarm manager"
  value       = aws_instance.manager.private_ip
}

output "worker_public_ip" {
  description = "Public IP of the swarm worker"
  value       = aws_instance.worker.public_ip
}

output "worker_private_ip" {
  description = "Private IP of the swarm worker"
  value       = aws_instance.worker.private_ip
}

output "inventory_example" {
  description = "Inventory snippet to copy into ansible/inventory/hosts.ini"
  value = <<-EOF
    [swarm_manager]
    swarm-manager ansible_host=${aws_instance.manager.public_ip} ansible_user=ec2-user

    [swarm_workers]
    swarm-worker-1 ansible_host=${aws_instance.worker.public_ip} ansible_user=ec2-user
  EOF
}
