# Monthly reporting query

## Scope
This artifact summarises the year-over-year reporting query shape used in the XR fundraising workflow.

## Purpose
The query supports grouped reporting over the `donations` table while keeping the reporting logic visible.

The query shape does three useful things:
- compares a selected current period with the matching period one year earlier;
- groups results dynamically by day, week, month, quarter, or year;
- splits recurring and one-off donations in the final aggregation.

## Verified query behaviour
The query:
- starts from `donations`;
- filters to `is_countable = TRUE`;
- constructs a current-period and previous-period view;
- aligns the previous-period dates by adding one year for side-by-side comparison;
- groups on a dynamic time bucket;
- returns both donation amount and donation count.

## Reporting value
This makes the dashboard useful for:
- month-over-month and year-over-year trend reading;
- recurring vs one-off comparison;
- high-level fundraising reporting without hiding the SQL logic behind opaque dashboard transformations.

## Public artifact
The SQL shape is included as:
- [`monthly-reports-yoy-query.sql`](monthly-reports-yoy-query.sql)

It is useful as a public artifact because it shows the reporting logic directly without exposing donor-level data.