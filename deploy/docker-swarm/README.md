# Docker Swarm Deployment

This folder contains the Docker Swarm deployment assets required by the assignment.

## Prerequisites

- Two EC2 instances or VMs with Docker installed
- Swarm initialized on the manager node
- Container images available to the manager and worker nodes

## Images

The upstream services use public images from Amazon ECR Public.

The custom `notification` service must be built and pushed to a registry that your
Swarm nodes can access, or preloaded on all nodes:

```bash
docker build -t retail-store-sample-notification:latest src/notification
```

## Deploy

On the manager node:

```bash
export DB_PASSWORD=change-me
export NOTIFICATION_IMAGE=retail-store-sample-notification:latest
docker stack deploy -c deploy/docker-swarm/stack.yml retail-store
```

## Validate

```bash
docker service ls
docker stack services retail-store
```

Open the UI:

```text
http://<manager-public-ip>:8888
```
