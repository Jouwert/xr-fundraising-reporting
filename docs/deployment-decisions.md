# Deployment decisions

## Scope
This document records the main deployment and reporting decisions in `xr-fundraising-reporting`.

It focuses on how the workflow is deployed, scheduled, verified, and kept trustworthy across:
- Kentaa;
- Exact Online;
- PostgreSQL;
- Metabase.

## The reporting workflow stays self-hosted on a VPS
The reporting stack runs in a self-hosted VPS environment rather than as a fully managed SaaS reporting bundle.

This keeps control over:
- the database layer;
- dashboard hosting;
- ETL runtime and scheduling;
- recovery and inspection workflows.

## The stack splits containers from ETL execution
The deployment uses Docker for the reporting platform and host-side `systemd` for ETL execution.

In practice that means:
- PostgreSQL, Metabase, and the tunnel run in a Compose stack;
- Python ETLs run from the VPS host through `systemd` services and timers.

The tunnel gives the dashboard a secure external route, while day-to-day dashboard access stays bounded through individual usernames/passwords instead of a single shared login.

This keeps the reporting platform stable while leaving ETL behaviour explicit and easy to inspect.

## Multiple source systems stay separate until they are loaded into the reporting model
Kentaa and Exact Online are different systems with different reporting roles.

The workflow does not pretend they are interchangeable.
Instead it keeps:
- source-specific ETL logic;
- explicit transformation rules;
- a shared reporting database after loading.

This makes the integration easier to reason about and safer to reconcile later.

## Reconciliation matters as much as dashboard uptime
A working dashboard is not enough if the numbers cannot be explained.

The workflow therefore treats these as first-class checks:
- ETL success;
- fresh database state;
- direct SQL verification;
- comparison with Exact Online reporting at month-end.

This keeps the reporting layer tied to finance-side reality instead of becoming a black box.

## The lifecycle model is derived explicitly rather than inferred indirectly in the dashboard
Recurring-donor reporting depends on a derived lifecycle model.

That logic is handled in a dedicated ETL step and stored in `recurring_donor_lifecycle` rather than being recreated ad hoc in dashboard questions.

In the Exact Online implementation, that lifecycle model is built from two sources:
- structured subscription records for standard recurring contracts;
- parsed account remarks for self-paying donors whose recurring pattern is recorded in free text.

Both paths are tied back to persistent hashed `donor_id` values so recurring state can be grouped without exposing donor identity.

This makes recurring reporting:
- easier to inspect;
- easier to rebuild;
- less dependent on fragile dashboard-only logic.

## Manual verification stays part of the operating model
This workflow deliberately keeps a manual check path.

That includes:
- ETL log inspection;
- database queries;
- month-end screenshot comparison against Exact Online;
- verification of the same totals in Metabase.

The goal is not maximum automation at any cost.
The goal is reporting that can be trusted and explained.

## Operational routines are scheduled, but intervention stays careful
The ETLs are automated with timers, but the broader support posture remains cautious.

That means:
- routine loading should happen automatically;
- suspicious results should be checked with direct DB queries;
- interventions should be deliberate rather than hidden inside opaque automation.

## Practical result
The deployment documented in this workflow has a clear shape:
- Kentaa and Exact Online provide the source data;
- Python ETLs load and derive reporting structures;
- PostgreSQL holds the reporting state;
- Metabase presents the reporting views;
- reconciliation keeps the whole chain trustworthy.

## Related documents
- [`README.md`](../README.md)
- [`architecture-overview.md`](architecture-overview.md)
- [`public-private-boundaries.md`](public-private-boundaries.md)