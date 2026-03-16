# platform-fleet

Multi-cluster platform engineering mono-repo.
Managed by eShoshoneDevOps.

## Structure

| Directory | Purpose |
|---|---|
| `clusters/hub` | Hub cluster — ArgoCD, Crossplane, Thanos Query |
| `clusters/spokes` | Spoke cluster configs — one dir per cluster |
| `platform-api` | Crossplane XRDs — self-service infra API |
| `gitops` | ArgoCD ApplicationSets — fleet-wide delivery |
| `terragrunt` | Cloud infra layering — AWS + GCP |
| `policies` | Kyverno + OPA policies — fleet-wide guardrails |
| `docs` | Architecture docs and internals references |

## Rules

1. Nothing in `spokes/` is unique — every spoke is a rendered instance of `_template/`
2. If it is not in an ApplicationSet it does not exist
3. No `kubectl apply` by hand — ever

## Status

- [ ] Hub cluster bootstrap
- [ ] First spoke cluster — gcp-dev
- [ ] ArgoCD ApplicationSet — cluster generator
- [ ] Terragrunt layer structure — GCP
- [ ] Cilium install + kube-proxy replacement
- [ ] External Secrets Operator
- [ ] Kyverno policy baseline
