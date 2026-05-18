# Retail Store SRE - EC2 Swarm Nodes

This Terraform configuration provisions two EC2 instances intended for:

- Docker Swarm manager and worker
- Ansible-managed host bootstrap
- End-term project deployment and monitoring demos

## What It Creates

- VPC and subnets using the shared VPC module
- Security group for SSH, application access, monitoring, and Swarm traffic
- One Swarm manager EC2 instance
- One Swarm worker EC2 instance

## Usage

```bash
cd terraform/ec2/swarm
terraform init
terraform plan -var="key_name=<your-ec2-keypair>"
terraform apply -var="key_name=<your-ec2-keypair>"
```

## Typical Next Steps

1. Copy the repository to the manager host
2. Update `ansible/inventory/hosts.ini` using the Terraform outputs
3. Run `ansible/playbooks/bootstrap.yml`
4. Run `ansible/playbooks/deploy-swarm.yml`
5. Run `ansible/playbooks/deploy-monitoring.yml`
