# ETL operations summary

## Scope
This artifact summarises how the XR fundraising reporting workflow is operated on the VPS.

## Runtime split
The deployment uses two runtime styles together.

### Container runtime
The Compose stack runs:
- PostgreSQL
- Metabase
- Cloudflare Tunnel

### Host runtime
The ETL jobs run as host-side Python processes with `systemd` services and timers.

This keeps the reporting stack persistent while leaving ETL execution explicit and easy to inspect.

## ETL components
The live project uses:
- `etl_scripts/kentaa_etl.py`
- `etl_scripts/exact_online_etl.py`
- `etl_scripts/exact_online_lifecycles_etl.py`

The deployment/service layer includes:
- `deployment/systemd/kentaa-etl.service`
- `deployment/systemd/exact-online-etl.service`
- `deployment/systemd/exact-online-lifecycles-etl.service`

The Kentaa service runs as a oneshot Python job from the VPS project directory with an explicit environment file and virtual environment path.

## Operational pattern
The ETL layer separates:
- raw Kentaa loading;
- raw Exact Online loading;
- recurring-donor lifecycle rebuilding.

That separation matters because recurring reporting depends on a derived lifecycle table rather than only on raw donation rows.

## Scheduling posture
A May 2026 recovery pass restored and staggered the Exact jobs so they did not fire together.

Verified schedule split from the shared project docs:
- raw Exact ETL at `*:05`
- lifecycle rebuild at `*:25`

This reduces overlap and makes failures easier to interpret.

## What operators check
The recurring operational rhythm focuses on:
- whether ETLs still run successfully;
- whether auth and connection failures are appearing;
- whether fresh data is still arriving in the database;
- whether the lifecycle rebuild still produces plausible reporting state.

## Why this matters
The reporting workflow is only trustworthy if operators can tell the difference between:
- dashboard issues;
- stale database state;
- ETL failures;
- source-system auth or rate-limit trouble.

The explicit service-and-timer structure keeps that chain visible.