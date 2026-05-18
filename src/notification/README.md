# Retail Store Sample App - Notification Service

| Language | Persistence |
| -------- | ----------- |
| Node     | In-memory   |

This service simulates outbound user notifications for the end-term SRE project.
It is intentionally lightweight and exists to satisfy the `6+ services` requirement
while also providing observability and chaos-testing hooks.

## Configuration

The following environment variables are available:

| Name | Description | Default |
| --- | --- | --- |
| `PORT` | HTTP listen port | `8080` |
| `NOTIFICATION_LOG_LEVEL` | Logging verbosity | `info` |

## Endpoints

| Method | Path | Description |
| --- | --- | --- |
| `GET` | `/health` | Liveness endpoint |
| `GET` | `/ready` | Readiness endpoint |
| `GET` | `/metrics` | Prometheus metrics |
| `GET` | `/notifications` | Returns in-memory notifications |
| `POST` | `/notify` | Creates a simulated notification |
| `POST` | `/chaos/status/{code}` | Force an HTTP status code for regular API requests |
| `DELETE` | `/chaos/status` | Disable forced HTTP status |
| `POST` | `/chaos/latency/{delay}` | Add artificial latency in milliseconds |
| `DELETE` | `/chaos/latency` | Disable artificial latency |
| `POST` | `/chaos/health` | Force health endpoints to fail |
| `DELETE` | `/chaos/health` | Restore healthy state |

## Running

### Local

```bash
npm install
npm start
```

### Docker

```bash
docker compose up
```
