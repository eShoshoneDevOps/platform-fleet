# Spoke baseline chart

Deployed to every spoke cluster via ArgoCD ApplicationSet.

## How it works

1. ArgoCD cluster generator finds all clusters labeled `platform.io/managed: "true"`
2. For each cluster, renders this chart with per-cluster values merged in order:
   - `values.yaml` (these defaults — lowest priority)
   - `clusters/spokes/<name>/values.yaml` (per-cluster overrides)
   - ApplicationSet parameters (highest priority — cluster name, env, cloud, region)
3. Helm downloads dependencies from Chart.lock before rendering
4. Syncs to the spoke cluster in wave order: Cilium → ESO → Kyverno → Prometheus

## Values hierarchy (last wins)

| Layer | File | Scope |
|---|---|---|
| Base defaults | `_template/values.yaml` | All clusters |
| Per-cluster | `spokes/<name>/values.yaml` | One cluster |
| Runtime | ApplicationSet parameters | Injected at sync |

## Adding a new spoke

1. Create `clusters/spokes/<cluster-name>/values.yaml`
2. Set required fields: clusterName, environment, cloud, region
3. Register cluster in ArgoCD with labels:
   - `platform.io/managed: "true"`
   - `platform.io/role: spoke`
   - `platform.io/environment: <dev|staging|prod>`
   - `platform.io/cloud: <aws|gcp|azure>`
4. ApplicationSet picks it up automatically on next sync — no other changes needed

## Local development
```bash
# Download dependencies locally for testing
helm dependency update .

# Render and inspect output for a specific cluster
helm template spoke-baseline . \
  -f values.yaml \
  -f ../gcp-dev/values.yaml \
  --set clusterName=gcp-dev \
  --set environment=dev \
  --set cloud=gcp \
  --set region=us-central1
```
