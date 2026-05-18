# End-Term SRE Project Plan

This document adapts the upstream sample application to the end-term assignment requirements.
It defines what must be implemented, in what order, and how success will be measured.

## Current Baseline

The repository already provides:

- Five deployable application services: `ui`, `catalog`, `cart`, `checkout`, `orders`
- Local orchestration with Docker Compose
- Kubernetes deployment artifacts through Helm charts and `helmfile`
- AWS infrastructure modules for EKS and ECS using Terraform
- Prometheus-compatible application metrics endpoints
- Chaos endpoints in several services for failure simulation
- Load generation utilities for scale and resilience tests

The repository does not yet provide the full set of end-term deliverables:

- A sixth microservice
- Docker Swarm deployment artifacts
- Ansible automation
- Prometheus, Alertmanager, and Grafana stack definitions
- Formal SLI/SLO definitions
- Alert rules and dashboard provisioning
- Incident runbook and postmortem assets
- Capacity-planning documentation backed by repeatable tests

## Target AWS Architecture

Use AWS in a way that satisfies both the assignment and budget constraints.

Recommended topology:

1. `EC2 manager` for Docker Swarm manager and Ansible control host
2. `EC2 worker` for Docker Swarm worker
3. `Amazon EKS` for Kubernetes deployment
4. `Amazon CloudWatch` for central log retention
5. `Prometheus + Alertmanager + Grafana` deployed either:
   - in Kubernetes for the Kubernetes environment
   - via Docker Compose or Swarm for the Swarm environment

Low-cost fallback:

1. Two EC2 instances for Swarm
2. One small EKS cluster for Kubernetes
3. Monitoring only in one environment, but metrics and screenshots collected for both

## Execution Order

### Phase 1: Service Topology

Objective: satisfy the `6+ services` criterion and make deployments consistent.

Tasks:

1. Add a `notification` service with health, metrics, and chaos endpoints
2. Add the service to Docker Compose
3. Add the service to Kubernetes via Helm
4. Document how the service participates in the architecture

Acceptance:

- `docker compose` starts six application services
- Kubernetes manifests include six application deployments
- The architecture diagram and README mention the sixth service

### Phase 2: Multi-Orchestration

Objective: demonstrate both orchestration approaches required by the assignment.

Tasks:

1. Keep Docker Compose for Assignment 1 local environment validation
2. Add Docker Swarm stack files and deployment guide
3. Keep Helm and Helmfile for Kubernetes deployment
4. Capture a short comparison of Swarm vs Kubernetes operational tradeoffs

Acceptance:

- `docker stack deploy` deploys the application in Swarm
- `helmfile apply` or `kubectl apply` deploys the application in Kubernetes
- Screenshots exist for both environments

### Phase 3: Infrastructure as Code

Objective: provision the AWS environment reproducibly.

Tasks:

1. Use the existing Terraform modules for EKS
2. Keep ECS as an optional comparison deployment path
3. If the instructor requires explicit VMs, add a small Terraform module for EC2 nodes used by Swarm and Ansible
4. Store variables, outputs, and environment-specific instructions in version control

Acceptance:

- `terraform init`, `plan`, and `apply` are documented for the chosen AWS path
- Outputs include endpoints and access instructions
- Security groups, networking, and node inventory are repeatable

### Phase 4: Configuration Management and Deployment Automation

Objective: automate setup and deployment using Ansible.

Tasks:

1. Create inventory and group variables for AWS hosts
2. Add a bootstrap playbook for Docker, kubectl, Helm, and utility packages
3. Add a Swarm deployment playbook
4. Add a Kubernetes deployment playbook
5. Add a monitoring deployment playbook

Acceptance:

- One command can bootstrap EC2 nodes
- One command can deploy the Swarm stack
- One command can deploy the monitoring stack

### Phase 5: Observability and SLOs

Objective: formalize and visualize reliability targets.

Tasks:

1. Define SLIs and SLOs for availability, latency, error rate, and request success rate
2. Add Prometheus scrape configuration
3. Add alert rules for service downtime, latency, error rate, and resource saturation
4. Add Grafana dashboard provisioning

Acceptance:

- Prometheus scrapes all services
- Grafana shows service health and performance
- Alertmanager routes alerts
- SLOs are stored in repository documentation

### Phase 6: Incident Simulation

Objective: demonstrate operational response and postmortem discipline.

Tasks:

1. Simulate an `orders` service database misconfiguration
2. Detect the incident via dashboards and alerts
3. Restore service availability
4. Record timeline, impact, root cause, corrective actions, and follow-ups

Acceptance:

- Incident can be reproduced on demand
- Mean time to detect and recover are recorded
- Postmortem exists in repository

### Phase 7: Capacity Planning

Objective: justify scaling decisions with measurements.

Tasks:

1. Run repeatable load tests with the load generator
2. Record CPU, memory, error rate, and latency under load
3. Identify the bottleneck service and datastore
4. Recommend horizontal and vertical scaling actions
5. Enable HPA for the most critical services where justified

Acceptance:

- Load-test evidence exists
- Resource bottlenecks are documented
- Scaling policy recommendations are tied to observed data

## Deliverables Checklist

The project is considered complete when the repository contains:

- Six application services
- Docker Compose setup
- Docker Swarm stack
- Kubernetes manifests or Helm deployment
- Terraform for the chosen AWS target
- Ansible inventory and playbooks
- Prometheus, Alertmanager, and Grafana configuration
- SLI and SLO documentation
- Incident runbook and postmortem
- Capacity-planning report
- Screenshots and evidence from AWS deployment

## Evidence to Capture

For the final submission keep a folder of screenshots showing:

1. Terraform apply output or AWS resources
2. Swarm service list and replicas
3. Kubernetes pods and services
4. Prometheus targets
5. Grafana dashboards
6. Fired alert
7. Incident timeline evidence
8. Recovery confirmation

## Recommended Demo Flow

1. Show architecture and AWS environment
2. Show both orchestration environments
3. Show metrics and dashboards
4. Trigger the incident
5. Show alert firing
6. Fix configuration and recover
7. Show restored metrics
8. Summarize SLOs and capacity decisions
