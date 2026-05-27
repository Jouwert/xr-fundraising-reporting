# Architecture overview

## Scope
This document gives a high-level view of the workflow documented in `xr-fundraising-reporting`.

It covers:
- the **Kentaa** fundraising data source;
- the **Exact Online** finance-side source;
- the **PostgreSQL reporting database**;
- the **Metabase dashboard layer**.

## Reporting context
This workflow exists to make fundraising reporting usable across more than one system.

Instead of treating one dashboard as the whole truth, the setup keeps four things connected:
- source-system imports;
- explicit ETL logic;
- inspectable database state;
- a reporting surface for recurring use.

That makes the workflow useful for operational reporting while still leaving a visible path back to source data and reconciliation.

## Architecture
The workflow consists of four layers: **source systems**, **ETL and transformation**, **reporting storage**, and **dashboard / verification**.

## Main layers

### 1. Source layer: Kentaa and Exact Online
The workflow starts from two different systems.

#### Kentaa
Kentaa provides campaign and donation-side fundraising data.

This layer contributes:
- donation records;
- recurring-donor information;
- fundraising-platform activity.

#### Exact Online
Exact Online provides finance-side donation and reporting context.

This layer contributes:
- ledger-oriented donation records;
- GL-account-linked reporting logic;
- structured subscription data plus self-paying account remarks used in lifecycle modelling;
- month-end reconciliation reference points.

The two systems are not identical in structure or purpose, so the workflow keeps the import logic explicit instead of hiding the differences.

### 2. ETL layer: Python jobs and scheduled runs
The ETL layer loads and transforms data from both source systems.

The main ETL components are:
- `etl_scripts/kentaa_etl.py`
- `etl_scripts/exact_online_etl.py`
- `etl_scripts/exact_online_lifecycles_etl.py`

This layer handles:
- API access;
- source-specific transformation rules;
- recurring-donor handling through a derived lifecycle model keyed by persistent hashed `donor_id` values;
- subscription-based extraction plus remark parsing for self-paying donors;
- database loading;
- operational scheduling.

The ETLs run as host-side Python jobs with `systemd` units and timers, while the reporting database and dashboard surface run in containers.

### 3. Storage layer: PostgreSQL reporting database
The PostgreSQL database is the central reporting surface.

Key tables include:
- `donations`
- `kentaa_recurring_donors`
- `exact_online_recurring_donors`
- `recurring_donor_lifecycle`
- `etl_page_status`

This layer holds:
- imported records from both source systems;
- state needed for resumable ETL operation;
- derived lifecycle views used for recurring-donor reporting;
- indexed structures for reporting and verification queries.

### 4. Reporting and verification layer: Metabase plus reconciliation
Metabase is the main dashboard surface.

This layer provides:
- operational dashboards;
- year-over-year reporting views;
- recurring-donor lifecycle reporting;
- decision-support outputs for recurring review.

But the workflow does not stop at the dashboard.
It also keeps a verification path through:
- direct database queries;
- ETL log checks;
- comparison with Exact Online reporting at month-end.

## Simplified flow
```text
Kentaa API                 Exact Online API
    │                            │
    ▼                            ▼
Kentaa ETL                Exact Online ETL + lifecycle ETL
    │                            │
    └──────────────┬─────────────┘
                   ▼
         PostgreSQL reporting database
                   │
          ┌────────┴────────┐
          ▼                 ▼
     Metabase dashboards    Direct SQL / reconciliation checks
          │                 │
          └────────┬────────┘
                   ▼
        Trusted fundraising reporting workflow
```

## Deployment shape
The deployment uses two different runtime styles together:

### Container side
The Docker Compose stack provides:
- PostgreSQL;
- Metabase;
- Cloudflare Tunnel.

The dashboard is exposed externally through the Cloudflare tunnel, while dashboard access itself stays bounded through user-specific usernames/passwords instead of one shared application login.

### Host side
The ETL jobs run from the VPS host with:
- a Python virtual environment;
- `systemd` services and timers;
- explicit working-directory and environment-file configuration.

This split keeps the dashboard stack stable while letting ETL runs stay explicit and inspectable.

## Trust and reconciliation model
A central design choice in this workflow is that dashboard numbers should remain explainable.

That means:
- ETL logic stays inspectable;
- database state can be queried directly;
- recurring-donor reporting uses an explicit derived lifecycle model;
- month-end checks can compare Exact Online reporting, DB totals, and Metabase outputs.

## Public documentation boundary
This repository documents:
- the relationship between source systems and dashboards;
- the ETL and reporting layers;
- the self-hosted deployment shape;
- the trust and reconciliation logic behind the workflow.

This repository does not publish:
- raw donor records;
- finance exports;
- credentials, tokens, or `.env` contents;
- internal dump files or unsanitized logs.