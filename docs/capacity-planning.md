# Capacity Planning

This document defines the capacity-planning workflow for the project.

## Goal

Determine which services and dependencies become bottlenecks under load and propose scaling actions backed by measurements.

## Test Method

Use the built-in load generator to create repeatable traffic against the application.

For each test run, capture:

1. Requests per second
2. P95 latency
3. Error rate
4. CPU usage
5. Memory usage
6. Restart count

## Services to Watch Closely

Highest focus:

1. `orders`
2. `checkout`
3. PostgreSQL

Secondary focus:

1. `catalog`
2. `ui`
3. Redis

## Planned Experiments

### Baseline

- Single replica for each service
- Default resource requests and limits
- Load for 5 to 10 minutes

### Stress Test

- Increase request volume until latency or error rate exceeds SLO
- Identify the first service to degrade

### Scale-Out Test

- Increase replicas for `orders` and `checkout`
- Compare latency and throughput against baseline

### Dependency Bottleneck Test

- Observe whether PostgreSQL, Redis, or RabbitMQ limits throughput before the application services do

## Expected Findings

Likely hotspots:

1. `orders` due to persistence and messaging
2. `checkout` due to orchestration of the purchase path
3. Databases under sustained write load

## Scaling Guidance

Horizontal scaling:

- Enable HPA for `orders`, `checkout`, and `ui`
- Increase replica count when CPU and latency trends justify it

Vertical scaling:

- Increase CPU and memory for database-backed services before extreme horizontal scale

Data layer:

- Tune PostgreSQL resources and connection settings
- Move stateful dependencies to managed AWS services where possible

## Reporting Template

For each test, record:

| Test Name | RPS | P95 Latency | Error Rate | CPU Hotspot | Memory Hotspot | Recommendation |
| --- | --- | --- | --- | --- | --- | --- |

Use this table in the final report and presentation.
