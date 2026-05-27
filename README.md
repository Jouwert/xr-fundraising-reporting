# xr-fundraising-reporting

Documentation for a fundraising reporting workflow built around **Kentaa**, **Exact Online**, **PostgreSQL**, and **Metabase**.

## What is in scope
This repository brings together four related parts of the workflow:
- **Kentaa ingestion** for campaign and donation data;
- **Exact Online ingestion** for finance-side reporting and reconciliation;
- a **PostgreSQL reporting layer** with derived recurring-donor lifecycle data;
- a **Metabase dashboard layer** for recurring reporting and decision support.

## Background
This workflow supports the online fundraising reporting environment of **Stichting Vrienden van XR**.

The practical goal is not just to show dashboard numbers. It is to make those numbers explainable across multiple systems and trustworthy enough for recurring operational use.

That means the reporting workflow is built around:
- source-system imports;
- explicit ETL logic;
- inspectable SQL and database state;
- dashboard views for day-to-day use;
- recurring reconciliation against finance-side reporting when needed.

## Components

### Kentaa data pipeline
The Kentaa side provides campaign and donation data for fundraising reporting.

Topics:
- API-based ingestion;
- resumable ETL behaviour;
- donor-ID hashing and privacy-aware handling;
- donation and recurring-donor imports.

### Exact Online pipeline
The Exact Online side adds finance-oriented donation and ledger context.

Topics:
- OAuth-based access;
- GL-account-based donation loading;
- stable hashed donor IDs derived from Exact account codes;
- recurring-donor detection through structured subscriptions plus parsed self-paying account remarks;
- recurring-donor lifecycle derivation;
- reconciliation-oriented reporting.

### Reporting database
The PostgreSQL layer holds imported source data plus derived reporting structures.

Topics:
- donations table as the core reporting surface;
- recurring donor and lifecycle tables;
- indexes and explicit transformation logic;
- inspectable query paths for verification.

### Dashboard and verification layer
Metabase provides the dashboard surface, but the workflow keeps raw DB checks and source reconciliation visible.

Topics:
- dashboard delivery;
- Cloudflare-published external access to the dashboard;
- user-specific dashboard logins rather than one shared dashboard credential;
- year-over-year reporting queries;
- monthly comparison against Exact Online totals;
- operational trust through reconciliation.

## Repository scope
This repository focuses on:
- reporting workflow structure;
- component boundaries;
- deployment decisions;
- the relationship between source systems, ETL jobs, database state, and dashboard outputs.

It does not include raw donor data, credentials, or private finance records.

## Repository contents
```text
xr-fundraising-reporting/
├── README.md
└── docs/
    ├── architecture-overview.md
    ├── candidates-sanitized-technical-artifacts.md
    ├── deployment-decisions.md
    ├── public-private-boundaries.md
    ├── sanitized-technical-artifacts.md
    └── artifacts/
        ├── data-pipeline-summary.md
        ├── donor-identity-model-summary.md
        ├── etl-operations-summary.md
        ├── lifecycle-model-summary.md
        ├── minimal-stack-compose.yaml
        ├── monthly-reporting-query.md
        └── monthly-reports-yoy-query.sql
```

## Public / private boundary
This repository documents architecture, reporting logic, and deployment judgement.
It does not publish:
- credentials or secrets;
- raw donor or finance data;
- private endpoints and operational access details;
- `.env` material, DB dumps, or internal support logs.

See [`docs/public-private-boundaries.md`](docs/public-private-boundaries.md).

## Current status
This repository documents the XR fundraising reporting workflow with a first set of sanitized technical artifacts derived from the real project materials and live deployment shape.

## Impact
- Before this workflow, the monthly fundraising report took roughly 2–3 hours to assemble manually. The dashboard replaced that with continuous access to the same reporting layer.
- Reporting is now available not only monthly but also weekly, which makes changes in fundraising performance visible much earlier.
- Fundraising staff, finance volunteers, and board members can inspect the same dashboard, reducing manual reporting handovers and improving shared understanding.
- The reporting layer exposes more detail in a more user-friendly way, while preserving privacy through bounded donor identity handling.
- This reduces manual reporting effort, lowers reconciliation risk, and makes it easier to act on trends before they become larger problems.

## Next likely additions
Optional next additions:
- a simple reporting-flow diagram;
- one public-facing example of a reconciliation check;
- one short ETL recovery note if it can be written cleanly without support-log detail.