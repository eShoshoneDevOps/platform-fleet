# ApplicationSets

Fleet-wide ArgoCD ApplicationSet definitions.
These are the single source of truth for what runs on which cluster.

## Generators in use
- Cluster generator — deploys to all clusters matching a label
- Matrix generator — cross product of clusters x apps
- Git generator — reads cluster list from this repo
