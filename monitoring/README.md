# Monitoring Stack

This folder contains the observability stack required by the end-term assignment:

- Prometheus for metrics collection
- Alertmanager for alert routing
- Grafana for visualization
- cAdvisor for container resource metrics
- Node Exporter for host metrics

## Local Usage

Start the application first, then run:

```bash
docker compose -f monitoring/docker-compose.yml up -d
```

Default endpoints:

- Prometheus: `http://localhost:9090`
- Alertmanager: `http://localhost:9093`
- Grafana: `http://localhost:3000`

Default Grafana credentials:

- Username: `admin`
- Password: `admin`

## Notes

- Prometheus scrapes application endpoints through `host.docker.internal`
- Adjust targets if you deploy the monitoring stack directly inside Swarm or Kubernetes
- The alert rules are intentionally simple and targeted at the assignment metrics
