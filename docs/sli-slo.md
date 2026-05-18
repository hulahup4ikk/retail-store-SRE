# SLI and SLO Definition

This document defines the reliability targets used for the end-term SRE project.

## Scope

Services in scope:

- `ui`
- `catalog`
- `cart`
- `checkout`
- `orders`
- `notification`

Primary business path:

1. Browse catalog
2. Add item to cart
3. Submit checkout
4. Persist order
5. Send notification event

## SLI Definitions

### Availability

Definition:

- Percentage of successful scrape intervals where a service is reachable and healthy

Prometheus-style signal:

- `up{job="<service>"}`
- Health endpoint status from blackbox probe or ingress probe

### Latency

Definition:

- P95 request latency for user-facing and order-processing endpoints

Prometheus-style signal:

- `histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m]))`
- Equivalent service-specific histogram metrics for Go and Node services

### Error Rate

Definition:

- Ratio of `5xx` responses to total requests over a rolling 5-minute window

Prometheus-style signal:

- `sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))`
- Equivalent Spring Boot request metrics where `http_requests_total` is not exposed directly

### Request Success Rate

Definition:

- Ratio of successful business requests to total business requests

Examples:

- Successful checkout submissions
- Successful order creation requests

## SLO Targets

| Metric | SLO | Window |
| --- | --- | --- |
| Availability | `>= 99.0%` | 30 days |
| P95 Latency | `<= 200 ms` for read paths, `<= 400 ms` for checkout and orders | 5 minutes rolling / monthly review |
| Error Rate | `<= 1%` | 30 days |
| Request Success Rate | `>= 99%` | 30 days |

## Error Budget

For the availability SLO of `99.0%`, the monthly error budget is approximately:

- `0.01 x 30 days = 7h 12m` of allowed unavailability

Use this budget to explain whether incidents are acceptable, and whether releases should pause after major reliability regressions.

## Service Priorities

Highest priority:

1. `orders`
2. `checkout`
3. `ui`

Medium priority:

1. `catalog`
2. `cart`

Lower priority:

1. `notification`

## Review Process

Review SLO compliance after each test cycle:

1. Baseline under normal load
2. Load-test run
3. Incident simulation
4. Post-recovery validation
