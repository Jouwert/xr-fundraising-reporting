# Sanitized technical artifacts

This repository includes a small set of sanitized technical artifacts derived from the real XR fundraising project home and the live VPS repo.

## Implemented artifacts

### Data pipeline summary
[`artifacts/data-pipeline-summary.md`](artifacts/data-pipeline-summary.md)

Shows how Kentaa and Exact Online are loaded into one reporting database and then surfaced in Metabase.

### ETL operations summary
[`artifacts/etl-operations-summary.md`](artifacts/etl-operations-summary.md)

Summarises the scheduled ETL shape, including host-side `systemd` jobs and the separation between raw loading and lifecycle rebuilds.

### Lifecycle model summary
[`artifacts/lifecycle-model-summary.md`](artifacts/lifecycle-model-summary.md)

Summarises the derived recurring-donor lifecycle layer used for recurring reporting and recovery, including the two-source Exact logic: structured subscriptions plus parsed self-paying remarks.

### Donor identity model summary
[`artifacts/donor-identity-model-summary.md`](artifacts/donor-identity-model-summary.md)

Explains the stable peppered-hash approach used to link donor activity without publishing direct donor identity, including the source-specific anchors used in Kentaa and Exact Online.

### Minimal stack compose example
[`artifacts/minimal-stack-compose.yaml`](artifacts/minimal-stack-compose.yaml)

Shows the three-service deployment shape used for PostgreSQL, Metabase, and Cloudflare Tunnel.

### Monthly reporting query
- [`artifacts/monthly-reporting-query.md`](artifacts/monthly-reporting-query.md)
- [`artifacts/monthly-reports-yoy-query.sql`](artifacts/monthly-reports-yoy-query.sql)

Shows the year-over-year reporting query shape used for grouped dashboard views over countable donations.
