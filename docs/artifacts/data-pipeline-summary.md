# Data pipeline summary

## Scope
This artifact summarises the main reporting path in the XR fundraising workflow.

It is based on the live VPS repo structure and the shared project-home documentation.

## Source systems
The workflow combines two main source systems.

### Kentaa
Kentaa provides fundraising-platform data such as donations and recurring-donor records.

The Kentaa ETL is implemented in:
- `etl_scripts/kentaa_etl.py`

That script includes:
- resumable page-based fetching;
- database-backed ETL page status;
- transformation of donation and recurring-donor records;
- hashed `donor_id` generation via a secret pepper.

### Exact Online
Exact Online provides finance-side reporting context.

The Exact pipeline is implemented in:
- `etl_scripts/exact_online_etl.py`
- `etl_scripts/exact_online_lifecycles_etl.py`

Those scripts cover:
- OAuth token refresh;
- GL-account lookup and donation loading;
- recurring-donor / lifecycle derivation.

## Reporting database
The central reporting layer is PostgreSQL.

Verified key tables in the schema include:
- `donations`
- `kentaa_recurring_donors`
- `exact_online_recurring_donors`
- `recurring_donor_lifecycle`
- `etl_page_status`

This structure keeps:
- imported donation records;
- recurring-donor state;
- ETL progress state;
- derived lifecycle reporting state.

## Dashboard layer
Metabase sits on top of the reporting database.

It provides:
- operational fundraising dashboards;
- year-over-year reporting views;
- recurring-donor reporting based on the lifecycle model.

## Simplified pipeline
```text
Kentaa API ────────┐
                   │
                   ▼
             Kentaa ETL ───────────────┐
                                       │
Exact Online API ──┐                   │
                   ▼                   ▼
           Exact Online ETL     Lifecycle ETL
                   └──────────────┬──────────┘
                                  ▼
                        PostgreSQL reporting DB
                                  │
                                  ▼
                           Metabase dashboards
```

## Why this matters
The workflow does not depend on one opaque dashboard layer.
It keeps the reporting path inspectable from:
- source-system ETLs;
- database schema and query paths;
- dashboard outputs.

That makes it easier to explain, troubleshoot, and reconcile.