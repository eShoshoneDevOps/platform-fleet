# ArgoCD ApplicationSets — how they actually work

## The atomic unit: Application

Every Application answers three questions:

- **Source** — where is the config? (Git repo + path)
- **Destination** — where does it go? (cluster + namespace)  
- **SyncPolicy** — manual or automatic?

Application objects live on the HUB cluster.
They reach out and deploy to SPOKE clusters.
The hub is the brain. Spokes are targets.

## The scaling problem

5 clusters × 4 apps = 20 Application YAML files.
All nearly identical.
Add a cluster — write 4 more files.
Add an app — write 5 more files.
This does not scale. ApplicationSet solves this.

## ApplicationSet = factory
```
ApplicationSet = Generator + Template
                     ↓            ↓
              what to loop    what to create
```

The generator produces a list of key-value maps.
The template is an Application definition with {{.variables}}.
For each item the generator produces, one Application is created.

## The three generators

### Clusters generator
Loops over every cluster registered in ArgoCD.
One cluster = one Application.
```yaml
generators:
- clusters:
    selector:           # filter — only matching clusters
      matchLabels:
        platform.io/managed: "true"
        platform.io/role: spoke
```

The selector is not a separate thing from clusters —
it is a filter inside the clusters generator.
Without selector: every cluster including the hub gets targeted.
With selector: only clusters matching the labels.

Think of it as SQL:
SELECT * FROM clusters WHERE managed = true AND role = spoke

### List generator
Loops over a static list you define inline.
One list item = one Application.
```yaml
generators:
- list:
    elements:
    - app: cilium
      wave: "1"
    - app: eso
      wave: "2"
```

### Matrix generator
Combines two generators. Cross product.
A items × B items = A×B Applications.
```yaml
generators:
- matrix:
    generators:
    - clusters:      # generator A — 3 clusters
        selector: ...
    - list:          # generator B — 4 apps
        elements: ...
# Result: 3 × 4 = 12 Applications
```

## Sync waves

Waves control deploy order across dependencies.
ArgoCD reads the sync-wave annotation on each Application.
Within a wave: all clusters deploy in parallel.
Between waves: ArgoCD waits for all items in wave N to be healthy.
```
Wave 1: cilium      — all clusters in parallel → wait for healthy
Wave 2: eso         — all clusters in parallel → wait for healthy
Wave 3: kyverno     — all clusters in parallel → wait for healthy
Wave 4: prometheus  — all clusters in parallel
```

Why this order:
- Cilium must be wave 1 — it is the network. Nothing else can get 
  network rules programmed without it.
- ESO must be wave 2 — apps need secrets before they start.
- Kyverno must be wave 3 — must be enforcing before workloads deploy.
- Prometheus is wave 4 — it is a workload, depends on all of the above.

## Worked example

3 clusters × 4 apps = 12 Application objects created:

gcp-dev-cilium    aws-dev-cilium    aws-prod-cilium    ← wave 1, parallel
gcp-dev-eso       aws-dev-eso       aws-prod-eso       ← wave 2, parallel
gcp-dev-kyverno   aws-dev-kyverno   aws-prod-kyverno   ← wave 3, parallel
gcp-dev-prometheus aws-dev-prometheus aws-prod-prometheus ← wave 4, parallel

Add a 4th cluster: 4 new Applications created automatically.
Add a 5th app at wave 2: 3 new Applications created, deploy after ESO wave.
No manual file changes needed. The factory handles it.
