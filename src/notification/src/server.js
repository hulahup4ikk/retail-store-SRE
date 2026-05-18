const express = require("express");
const client = require("prom-client");

const app = express();
const register = new client.Registry();

client.collectDefaultMetrics({ register });

const requestDuration = new client.Histogram({
  name: "http_request_duration_seconds",
  help: "HTTP request duration in seconds",
  labelNames: ["method", "route", "status"],
  buckets: [0.05, 0.1, 0.2, 0.5, 1, 2, 5],
  registers: [register],
});

const requestCount = new client.Counter({
  name: "http_requests_total",
  help: "Total HTTP requests",
  labelNames: ["method", "route", "status"],
  registers: [register],
});

const notificationEvents = new client.Counter({
  name: "notification_events_total",
  help: "Total simulated notification events",
  labelNames: ["channel", "status"],
  registers: [register],
});

const port = parseInt(process.env.PORT || "8080", 10);
const notifications = [];
const chaosState = {
  statusCode: null,
  latencyMs: 0,
  healthy: true,
};

app.use(express.json());

app.use(async (req, res, next) => {
  const start = process.hrtime.bigint();
  const routeLabel = req.path;

  res.on("finish", () => {
    const durationSeconds =
      Number(process.hrtime.bigint() - start) / 1000000000;
    const labels = {
      method: req.method,
      route: routeLabel,
      status: String(res.statusCode),
    };

    requestDuration.observe(labels, durationSeconds);
    requestCount.inc(labels);
  });

  if (!chaosState.healthy && (req.path === "/health" || req.path === "/ready")) {
    res.status(503).json({ status: "unhealthy" });
    return;
  }

  if (!req.path.startsWith("/chaos") && !req.path.startsWith("/metrics")) {
    if (chaosState.latencyMs > 0) {
      await new Promise((resolve) => setTimeout(resolve, chaosState.latencyMs));
    }

    if (chaosState.statusCode !== null) {
      res.status(chaosState.statusCode).json({
        error: "Chaos status override enabled",
      });
      return;
    }
  }

  next();
});

app.get("/health", (_req, res) => {
  res.json({ status: "ok" });
});

app.get("/ready", (_req, res) => {
  res.json({ status: "ready" });
});

app.get("/notifications", (_req, res) => {
  res.json({ count: notifications.length, items: notifications });
});

app.post("/notify", (req, res) => {
  const notification = {
    id: notifications.length + 1,
    channel: req.body.channel || "email",
    recipient: req.body.recipient || "demo@example.com",
    subject: req.body.subject || "Retail Store Notification",
    message: req.body.message || "This is a simulated notification event.",
    createdAt: new Date().toISOString(),
  };

  notifications.push(notification);
  notificationEvents.inc({
    channel: notification.channel,
    status: "success",
  });

  res.status(201).json(notification);
});

app.get("/chaos", (_req, res) => {
  res.json(chaosState);
});

app.post("/chaos/status/:code", (req, res) => {
  const code = parseInt(req.params.code, 10);
  if (Number.isNaN(code) || code < 100 || code > 599) {
    res.status(400).json({ error: "Invalid HTTP status code." });
    return;
  }

  chaosState.statusCode = code;
  res.status(201).json({ message: `Status override set to ${code}` });
});

app.delete("/chaos/status", (_req, res) => {
  chaosState.statusCode = null;
  res.json({ message: "Status override disabled" });
});

app.post("/chaos/latency/:ms", (req, res) => {
  const latencyMs = parseInt(req.params.ms, 10);
  if (Number.isNaN(latencyMs) || latencyMs < 0) {
    res.status(400).json({
      error: "Invalid latency value. Please provide a positive integer.",
    });
    return;
  }

  chaosState.latencyMs = latencyMs;
  res.status(201).json({ message: `Latency set to ${latencyMs}ms` });
});

app.delete("/chaos/latency", (_req, res) => {
  chaosState.latencyMs = 0;
  res.json({ message: "Latency disabled" });
});

app.post("/chaos/health", (_req, res) => {
  chaosState.healthy = false;
  res.status(201).json({ message: "Health failure enabled" });
});

app.delete("/chaos/health", (_req, res) => {
  chaosState.healthy = true;
  res.json({ message: "Health restored" });
});

app.get("/metrics", async (_req, res) => {
  res.set("Content-Type", register.contentType);
  res.end(await register.metrics());
});

app.listen(port, () => {
  console.log(`notification service listening on port ${port}`);
});
