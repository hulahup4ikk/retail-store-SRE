# Postmortem: Orders Service Database Misconfiguration

## Summary

An incident was triggered by deploying the `orders` service with an incorrect PostgreSQL configuration.
The service became unavailable for order creation, causing checkout failures for affected requests.

## Impact

- Order creation unavailable
- Checkout flow partially degraded
- Increased `5xx` rate on the purchase path

## Detection

- Alert: `OrdersServiceDown`
- Alert: `OrdersHighLatency`
- Dashboard showed failed readiness and increased errors

## Timeline

Use absolute timestamps during the real run:

| Time | Event |
| --- | --- |
| `T0` | Bad configuration deployed |
| `T0 + X` | Alert fired |
| `T0 + Y` | Root cause identified |
| `T0 + Z` | Correct configuration applied |
| `T0 + N` | Service healthy and traffic restored |

## Root Cause

The `orders` service was configured with invalid database connection details.
This caused application startup or dependency access failures and prevented successful order processing.

## Contributing Factors

- Missing pre-deployment configuration validation
- No explicit secret verification step in deployment flow
- Insufficient environment-specific safeguards

## Resolution

1. Validate database endpoint, username, password, and database name
2. Re-apply corrected configuration
3. Restart the affected service
4. Confirm service health and successful order creation

## Preventive Actions

1. Add configuration validation to deployment automation
2. Add smoke tests after deployment
3. Add a runbook step to verify secrets before rollout
4. Keep incident screenshots and logs attached to the report
