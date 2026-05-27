# Lifecycle model summary

## Scope
This artifact summarises the recurring-donor lifecycle layer used in the XR fundraising reporting workflow.

## Purpose
Recurring reporting in this project depends on more than raw donation rows.
It uses a derived lifecycle model so recurring-donor status can be rebuilt and reported more explicitly.

## Main structures
Verified schema elements include:
- `exact_online_recurring_donors`
- `recurring_donor_lifecycle`

The lifecycle rebuild logic lives in:
- `etl_scripts/exact_online_lifecycles_etl.py`

## Identity and matching
This lifecycle model is tied together with persistent hashed `donor_id` values.

In the Exact implementation, donor lifecycle profiles are keyed from account codes through a peppered hash so recurring behaviour can be tracked without storing direct donor identity in the reporting layer.

## Two-source recurring-donor detection
The Exact lifecycle build does not rely on one signal only.
It combines two paths:

### 1. Structured subscription records
The primary path reads Exact Online subscription objects and their recurring line items.

That produces lifecycle profiles with:
- start date from the subscription start;
- end date from cancellation or contract end;
- inferred frequency from the subscription type;
- recurring amount from recurring subscription lines.

### 2. Parsed account remarks for self-paying donors
A fallback path processes account remarks for donors who are not represented through the normal subscription structure.

The lifecycle ETL parses free-text remarks to extract:
- frequency markers such as monthly, quarterly, half-yearly, or yearly;
- amount markers;
- start and end years where present.

These profiles are stored separately in the lifecycle model rather than disappearing from recurring reporting.

## Why this layer exists
This layer makes recurring reporting:
- easier to inspect;
- easier to recover after ETL problems;
- less dependent on fragile dashboard-only logic.

Instead of rebuilding lifecycle state inside Metabase questions every time, the workflow stores a dedicated derived table in PostgreSQL.

## Operational role
The lifecycle table is important enough that recovery work has explicitly targeted it.

A May 2026 recovery rebuilt the lifecycle layer after it had dropped to zero rows.
The shared project documentation records a rebuild to:
- `383` lifecycle profiles
- `347` active lifecycle profiles

The same progress record also preserved the source split in that rebuild:
- `ExactOnline_Subscription`: `304`
- `ExactOnline_Remarks`: `79`

That recovery mattered because recurring-donor cards in the dashboard depended on this derived table.

## Practical meaning
This reporting workflow separates:
- raw import of source-system records;
- derived recurring-donor interpretation for dashboard use.

That separation improves both reporting clarity and recovery speed.