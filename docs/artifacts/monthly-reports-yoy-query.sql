WITH current_period AS (
    SELECT donation_date, "is_recurring", amount
    FROM donations
    WHERE {{date_filter}} AND is_countable = TRUE
),
date_boundaries AS (
    SELECT MIN(donation_date) AS current_start, MAX(donation_date) AS current_end
    FROM current_period
),
previous_period AS (
    SELECT donation_date, "is_recurring", amount
    FROM donations
    WHERE is_countable = TRUE
      AND donation_date BETWEEN (SELECT current_start - INTERVAL '1 year' FROM date_boundaries)
                                  AND (SELECT current_end - INTERVAL '1 year' FROM date_boundaries)
),
combined_data AS (
    SELECT donation_date AS display_date, 'Current' AS period, "is_recurring", amount
    FROM current_period
    UNION ALL
    SELECT donation_date + INTERVAL '1 year' AS display_date, 'Previous' AS period, "is_recurring", amount
    FROM previous_period
)
SELECT
    date_trunc(
        CASE {{tijdsgroepering}}
            WHEN 'Dag' THEN 'day'
            WHEN 'Week' THEN 'week'
            WHEN 'Maand' THEN 'month'
            WHEN 'Kwartaal' THEN 'quarter'
            WHEN 'Jaar' THEN 'year'
            ELSE 'week'
        END,
        display_date
    )::date AS "Donation Date",
    period AS "Period",
    CASE WHEN "is_recurring" = TRUE THEN 'Vaste Donaties' ELSE 'Eenmalige Donaties' END AS "Donation Type",
    SUM(amount) AS "Sum of Amount",
    COUNT(*) AS "Count of Donations"
FROM combined_data
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3
