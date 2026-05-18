![Banner](./docs/images/banner.png)

<div align="center">
  <div align="center">

[![Stars](https://img.shields.io/github/stars/aws-containers/retail-store-sample-app)](Stars)
![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Faws-containers%2Fretail-store-sample-app%2Frefs%2Fheads%2Fmain%2F.release-please-manifest.json&query=%24%5B%22.%22%5D&label=release)
![GitHub Release Date](https://img.shields.io/github/release-date/aws-containers/retail-store-sample-app)

  </div>

  <strong>
  <h2>Retail Store SRE Project</h2>
  </strong>
</div>

This repository is based on the AWS retail sample application and adapted for an end-term SRE project. It keeps the original store workflow while adding the automation, monitoring, and operational assets needed for deployment practice and reliability exercises.

It includes:

- A demo store-front application with themes, pages to show container and application topology information, generative AI chat bot and utility functions for experimentation and demos.
- An optional distributed component architecture using various languages and frameworks
- A variety of different persistence backends for the various components like MariaDB (or MySQL), DynamoDB and Redis
- The ability to run in different container orchestration technologies like Docker Compose, Kubernetes etc.
- Pre-built container images for both x86-64 and ARM64 CPU architectures
- All components instrumented for Prometheus metrics and OpenTelemetry OTLP tracing
- Support for Istio on Kubernetes
- Load generator which exercises all of the infrastructure
- End-term SRE project assets for Docker Swarm, Ansible, Prometheus, Alertmanager, Grafana, incident response, and capacity planning

See the [features documentation](./docs/features.md) for more information.

**This project is intended for educational purposes only and not for production use**

![Screenshot](/docs/images/screenshot.png)

## Application Architecture

The application has been deliberately over-engineered to generate multiple de-coupled components. These components generally have different infrastructure dependencies, and may support multiple "backends" (example: Carts service supports MongoDB or DynamoDB).

![Architecture](/docs/images/architecture.png)

| Component                  | Language | Container Image                                                             | Helm Chart                                                                        | Description                             |
| -------------------------- | -------- | --------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | --------------------------------------- |
| [UI](./src/ui/)                      | Java     | [Link](https://gallery.ecr.aws/aws-containers/retail-store-sample-ui)       | [Link](https://gallery.ecr.aws/aws-containers/retail-store-sample-ui-chart)       | Store user interface                    |
| [Catalog](./src/catalog/)            | Go       | [Link](https://gallery.ecr.aws/aws-containers/retail-store-sample-catalog)  | [Link](https://gallery.ecr.aws/aws-containers/retail-store-sample-catalog-chart)  | Product catalog API                     |
| [Cart](./src/cart/)                  | Java     | [Link](https://gallery.ecr.aws/aws-containers/retail-store-sample-cart)     | [Link](https://gallery.ecr.aws/aws-containers/retail-store-sample-cart-chart)     | User shopping carts API                 |
| [Orders](./src/orders)               | Java     | [Link](https://gallery.ecr.aws/aws-containers/retail-store-sample-orders)   | [Link](https://gallery.ecr.aws/aws-containers/retail-store-sample-orders-chart)   | User orders API                         |
| [Checkout](./src/checkout)           | Node     | [Link](https://gallery.ecr.aws/aws-containers/retail-store-sample-checkout) | [Link](https://gallery.ecr.aws/aws-containers/retail-store-sample-checkout-chart) | API to orchestrate the checkout process |
| [Notification](./src/notification/)  | Node     | Build locally or publish to your own registry                                | [Local chart](./src/notification/chart/)                                           | Simulated outbound notification service |

## Quickstart

The following sections provide quickstart instructions for various platforms.

### Docker

This deployment method will run the application as a single container on your local machine using `docker`.

Pre-requisites:

- Docker installed locally

Run the container:

```text
docker run -it --rm -p 8888:8080 public.ecr.aws/aws-containers/retail-store-sample-ui:1.0.0
```

Open the frontend in a browser window:

```text
http://localhost:8888
```

To stop the container in `docker` use Ctrl+C.

### Docker Compose

This deployment method will run the application on your local machine using `docker-compose`.

Pre-requisites:

- Docker installed locally

Download the latest Docker Compose file and use `docker compose` to run the application containers:

```text
wget https://github.com/aws-containers/retail-store-sample-app/releases/latest/download/docker-compose.yaml

DB_PASSWORD='<some password>' docker compose --file docker-compose.yaml up
```

Open the frontend in a browser window:

```text
http://localhost:8888
```

To stop the containers in `docker compose` use Ctrl+C. To delete all the containers and related resources run:

```text
docker compose -f docker-compose.yaml down
```

### Docker Swarm

This repository includes Docker Swarm deployment assets for the end-term SRE project.

See:

- [deploy/docker-swarm/README.md](./deploy/docker-swarm/README.md)
- [deploy/docker-swarm/stack.yml](./deploy/docker-swarm/stack.yml)

### Kubernetes

This deployment method will run the application in an existing Kubernetes cluster.

Pre-requisites:

- Kubernetes cluster
- `kubectl` installed locally

Use `kubectl` to run the application:

```text
kubectl apply -f https://github.com/aws-containers/retail-store-sample-app/releases/latest/download/kubernetes.yaml
kubectl wait --for=condition=available deployments --all
```

Get the URL for the frontend load balancer like so:

```text
kubectl get svc ui
```

To remove the application use `kubectl` again:

```text
kubectl delete -f https://github.com/aws-containers/retail-store-sample-app/releases/latest/download/kubernetes.yaml
```

### Terraform

The following options are available to deploy the application using Terraform:

| Name                                             | Description                                                                                                     |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------- |
| [AWS EC2 (Swarm Nodes)](./terraform/ec2/swarm/)  | Provisions EC2 instances intended for Docker Swarm, Ansible automation, and end-term SRE demonstrations.      |
| [Amazon EKS](./terraform/eks/default/)           | Deploys the application to Amazon EKS using other AWS services for dependencies, such as RDS, DynamoDB etc.   |
| [Amazon EKS (Minimal)](./terraform/eks/minimal/) | Deploys the application to Amazon EKS using in-cluster dependencies instead of RDS, DynamoDB etc.             |
| [Amazon ECS](./terraform/ecs/default/)           | Deploys the application to Amazon ECS using other AWS services for dependencies, such as RDS, DynamoDB etc.   |
| [AWS App Runner](./terraform/apprunner/)         | Deploys the application to AWS App Runner using other AWS services for dependencies, such as RDS, DynamoDB etc. |

## End-Term SRE Assets

The repository now includes project assets aligned to the end-term assignment criteria:

- [Project plan](./docs/endterm-project-plan.md)
- [SLI and SLO definitions](./docs/sli-slo.md)
- [Incident response runbook](./docs/incident-response.md)
- [Incident postmortem](./docs/postmortems/order-service-db-misconfig.md)
- [Capacity planning notes](./docs/capacity-planning.md)
- [Monitoring stack](./monitoring/README.md)
- [Ansible automation](./ansible/README.md)

## Repository Focus

This repo is organized around two parallel tracks:

- Application deployment targets: Docker, Docker Compose, Docker Swarm, Kubernetes, and Terraform-based AWS environments
- SRE deliverables: monitoring, alerting, automation, incident response, and capacity-planning documentation

For the project-specific operations flow, start with:

- [deploy/docker-swarm/README.md](./deploy/docker-swarm/README.md)
- [monitoring/README.md](./monitoring/README.md)
- [ansible/README.md](./ansible/README.md)
