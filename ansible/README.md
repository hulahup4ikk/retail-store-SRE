# Ansible Automation

This folder contains the Ansible assets used to satisfy the configuration-management
requirement of the end-term SRE project.

## Layout

- `inventory/hosts.ini`: example inventory for AWS EC2 hosts
- `group_vars/all.yml`: shared variables
- `playbooks/bootstrap.yml`: install Docker and common tooling
- `playbooks/deploy-swarm.yml`: initialize Swarm and deploy the stack
- `playbooks/deploy-monitoring.yml`: deploy the monitoring stack on a host
- `playbooks/deploy-eks-app.yml`: update kubeconfig and deploy the app to EKS

## Example Usage

Bootstrap EC2 nodes:

```bash
ansible-playbook -i inventory/hosts.ini playbooks/bootstrap.yml
```

Deploy Swarm:

```bash
ansible-playbook -i inventory/hosts.ini playbooks/deploy-swarm.yml
```

Deploy monitoring:

```bash
ansible-playbook -i inventory/hosts.ini playbooks/deploy-monitoring.yml
```

Deploy the app to EKS from the control host:

```bash
ansible-playbook playbooks/deploy-eks-app.yml
```
