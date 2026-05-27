# Public / Private Boundaries

## Purpose
This document defines what should and should not be published in the public `xr-fundraising-reporting` repository.

The goal is credibility, not maximum disclosure.
A strong public repository explains reporting architecture and deployment judgement clearly without exposing donor data, finance-sensitive detail, or operational secrets.

## Scope of the public case
This public repository describes one connected reporting workflow built around:
- the Kentaa fundraising platform;
- Exact Online finance-side reporting;
- a PostgreSQL reporting database;
- a Metabase dashboard layer.

It should explain how those pieces relate.
It should not expose raw reporting data from any of them.

## Publication rule
When deciding whether something belongs in the public repo, ask:
1. Does this improve credibility?
2. Does it explain data flow, deployment judgement, or reporting logic?
3. Can it be shared without exposing donor, finance, or access-sensitive detail?
4. Would a careful external reviewer reasonably expect this to be public?

If the answer is unclear, keep it private until it is sanitized properly.

## Public now
These are good candidates for direct public inclusion.

### Framing and documentation
- repository README
- architecture overview
- deployment-decision notes
- explanation of reconciliation and trust model
- concise explanation of source systems, ETL layers, and dashboard flow

### Sanitized technical material
- selected ETL summaries with secrets removed
- simplified Compose or service examples without live secrets
- SQL examples that show reporting logic without private data
- schema summaries and table descriptions
- diagrams showing system components and data flow

### Credibility artifacts
- evidence that the workflow ran in a real VPS environment
- explanations of why direct DB checks remain important
- explanations of recurring-donor lifecycle modelling
- descriptions of month-end reconciliation workflow

## Public after cleanup or anonymisation
These can be useful, but only after review and sanitisation.

### Screenshots
- Metabase screenshots with private campaign and donor details removed
- screenshots of monthly comparison outputs with sensitive figures masked if needed
- timer or service screenshots redrawn into simple diagrams if that is cleaner

### Technical examples
- ETL snippets after checking for source-specific secrets or organisation identifiers
- troubleshooting examples rewritten to remove private operational detail
- schema excerpts with only structurally useful fields
- dashboard questions or cards rewritten as neutral public examples

### Workflow examples
- one synthetic or redacted month-end reconciliation example
- one sanitized dashboard walk-through
- one cleaned-up example of ETL freshness verification

## Private only
These should stay out of the public repo.

### Secrets and infrastructure details
- API keys, tokens, client secrets, certificates
- `.env` contents or `.env` backups
- access credentials for Metabase, SSH, Exact Online, or Kentaa
- tunnel tokens and private operational access paths

### Donor and finance-sensitive detail
- raw donor exports
- raw Kentaa or Exact Online records
- DB dumps
- real month-end screenshots with full finance details if they are not approved and sanitized
- internal reporting outputs that reveal more than the public case needs

### Internals that create unnecessary risk
- private support logs
- raw troubleshooting traces with sensitive environment detail
- unfiltered SQL results from production
- backup files and local recovery artifacts

## Special rule for compliance wording
Public wording should stay careful.

Prefer:
- *privacy-aware fundraising reporting workflow*
- *reconciliation-oriented reporting architecture*
- *self-hosted reporting stack with explicit verification paths*

Avoid strong legal or audit claims like:
- *fully compliant*
- *guaranteed financial truth*

Unless the public repository also documents the controls that justify that claim.

## Recommended public evidence mix
A strong public repository probably needs only:
- one concise README;
- one architecture overview;
- one public/private boundary note;
- a few sanitized technical artifacts;
- one small set of visuals later, if they add clarity.

That is enough to feel real without publishing internal reporting detail that does not belong in public.

## Reviewer mindset to optimise for
The public repo should make a reviewer think:
- this is real reporting infrastructure;
- this person understands integration and reconciliation;
- this person knows how to keep donor-sensitive work bounded;
- this person can explain dashboards, ETLs, and operational trust together;
- this is practical deployment work, not inflated data-platform theatre.

## Practical default
When in doubt:
- publish the explanation;
- keep the raw artifact private;
- use a sanitized excerpt instead of the full internal file.