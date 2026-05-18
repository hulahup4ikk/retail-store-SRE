# Incident Response Runbook

This runbook defines how to handle the required incident simulation for the project.

## Incident Scenario

`orders` service fails because the database configuration is invalid or the database becomes unreachable.

## Symptoms

- Checkout requests fail or stall
- Order creation returns `5xx`
- `orders` readiness probe fails
- Prometheus alerts fire for service availability or latency

## Detection

Primary detection methods:

1. Grafana service health dashboard
2. Prometheus alert `OrdersServiceDown`
3. Prometheus alert `OrdersHighLatency`
4. Kubernetes or Swarm restart events

## Triage Checklist

1. Confirm user impact at the UI or API level
2. Check `orders` health endpoint
3. Check service logs
4. Confirm database endpoint, username, password, and port
5. Verify dependent components such as PostgreSQL and RabbitMQ

## Recovery Steps

1. Restore the correct database configuration
2. Restart the affected `orders` service
3. Confirm readiness and liveness return to healthy
4. Retry an order submission
5. Confirm latency and error rate normalize in Grafana

## Communication

During the demo or report, capture:

1. Incident start time
2. Detection time
3. Recovery start time
4. Recovery complete time
5. User-facing impact

## Post-Incident Actions

1. Write the postmortem
2. Add preventive alerting if detection was slow
3. Add configuration validation if the root cause was manual error
4. Update deployment automation so the same failure is harder to repeat
