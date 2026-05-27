# Donor identity model summary

## Scope
This artifact summarises how the XR fundraising reporting workflow links donation activity at donor level without publishing direct donor identity in the reporting layer.

## Purpose
Recurring-donor reporting depends on being able to recognise when multiple records belong to the same donor.

This workflow does that with a stable, peppered hashed `donor_id` rather than exposing raw personal identifiers in reporting tables and dashboard logic.

## Main pattern
The reporting model stores a derived `donor_id` that is stable enough to group donor activity across ETL runs.

That ID is:
- deterministic for the same source-side identity anchor;
- generated with a secret pepper;
- used in reporting tables and lifecycle logic instead of direct personal identifiers.

## Source-specific identity anchors
The workflow does not use one identical identity rule for every source system.

### Kentaa
In the Kentaa ETL, donor identity is derived from the best available donor-side key in this order:
- `account_iban` when present;
- otherwise `email`;
- otherwise a fallback unlinked value tied to the source donation record.

That source string is combined with the pepper and hashed into `donor_id`.

This means Kentaa donations and Kentaa recurring-donor records can be linked without keeping raw bank-account or email fields in the reporting model.

### Exact Online
In the Exact Online ETL, donor identity is derived from the stable Exact account code.

That account code is combined with the same pepper and hashed into `donor_id` before Exact donation rows are loaded into the reporting database.

The Exact lifecycle ETL uses that same hashed account-code identity when building `recurring_donor_lifecycle`.

## Why this matters
This identity model makes it possible to:
- group donations at donor level;
- rebuild recurring-donor lifecycle state;
- compare recurring behaviour across ETL runs;
- keep dashboard logic focused on reporting rather than raw identity handling.

## Relationship to recurring-donor logic
The hashed `donor_id` is part of the foundation for recurring-donor reporting, but it is not the whole recurring model by itself.

For Exact Online, recurring status is still derived through lifecycle ETL logic built from:
- structured subscription records;
- parsed account remarks for self-paying donors.

The hashed `donor_id` provides the stable donor-level join key that lets those recurring signals be grouped safely in the reporting layer.

## Public boundary
This repository documents the identity model as a reporting and privacy mechanism.
It does not publish:
- the pepper value;
- raw IBANs, emails, or Exact account exports;
- unsanitized donor-level records.
