# Spoke cluster template

Every spoke directory is an instance of this template.
Override only what differs per cluster — everything else inherits from here.

## Required values per spoke
- `cluster-name`
- `cloud-provider` (aws | gcp | azure)
- `region`
- `environment` (dev | staging | prod)
