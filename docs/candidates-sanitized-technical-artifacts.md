# Candidate sanitized technical artifacts

This file tracks useful XR fundraising artifacts that could be added later if they improve the public case without exposing sensitive reporting detail.

## Good next candidates

### Sanitized Metabase screenshots
Possible additions:
- one high-level dashboard overview with campaign and donor-sensitive details removed;
- one recurring-donor view with private details masked;
- one KPI view showing the reporting surface without exposing raw finance content.

### Reconciliation example
Possible addition:
- one synthetic or heavily sanitized month-end comparison showing the workflow from Exact Online screenshot to DB totals to Metabase.

### Service and timer diagram
Possible addition:
- a simple diagram showing how `systemd` ETLs, the Compose stack, and the dashboard URL relate on the VPS.

### Troubleshooting case note
Possible addition:
- one short public write-up of an ETL recovery or scheduling issue, rewritten as a deployment-judgement example rather than an internal support log.

## Keep private unless rewritten carefully
These are real but should stay out of the public repo unless reduced to a safer form:
- raw month-end screenshots;
- production DB query outputs;
- internal troubleshooting logs;
- unfiltered service logs;
- repo-local backup and dump files.