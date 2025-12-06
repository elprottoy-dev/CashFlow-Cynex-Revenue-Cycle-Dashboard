USE rcm_project;

CREATE OR REPLACE VIEW v_claim_kpi_base AS
SELECT
    c.claim_id,
    c.patient_id,
    c.payer_id,
    p.payer_name,
    c.service_date,
    c.claim_submit_date,
    c.payment_date,
    c.billed_amount,
    c.paid_amount,
    c.adjustment_amount,
    c.claim_status,
    c.denial_reason,
    YEAR(c.service_date)  AS service_year,
    MONTH(c.service_date) AS service_month,
    CASE 
        WHEN c.payment_date IS NOT NULL THEN DATEDIFF(c.payment_date, c.claim_submit_date)
        ELSE DATEDIFF(CURDATE(), c.claim_submit_date)
    END AS days_in_ar,
    CASE WHEN c.claim_status = 'Denied' THEN 1 ELSE 0 END AS is_denied,
    CASE WHEN c.claim_status = 'Paid'   THEN 1 ELSE 0 END AS is_paid,
    CASE 
        WHEN c.billed_amount > 0 
        THEN c.paid_amount / c.billed_amount 
        ELSE 0 
    END AS net_collections_ratio
FROM fact_claim c
LEFT JOIN dim_payer p ON c.payer_id = p.payer_id;

-- Monthly KPIs
SELECT
    service_year,
    service_month,
    COUNT(*) AS total_claims,
    SUM(billed_amount) AS total_billed,
    SUM(paid_amount)   AS total_paid,
    AVG(days_in_ar)    AS avg_days_in_ar,
    100 * SUM(is_denied) / COUNT(*) AS denial_rate_pct,
    100 * SUM(paid_amount) /
        NULLIF(SUM(billed_amount - COALESCE(adjustment_amount,0)), 0)
        AS net_collection_rate_pct
FROM v_claim_kpi_base
GROUP BY service_year, service_month
ORDER BY service_year, service_month;

-- Payer KPIs
SELECT
    payer_name,
    service_year,
    service_month,
    COUNT(*) AS total_claims,
    SUM(billed_amount) AS total_billed,
    SUM(paid_amount)   AS total_paid,
    AVG(days_in_ar)    AS avg_days_in_ar,
    100 * SUM(is_denied) / COUNT(*) AS denial_rate_pct,
    100 * SUM(paid_amount) /
        NULLIF(SUM(billed_amount - COALESCE(adjustment_amount,0)), 0)
        AS net_collection_rate_pct
FROM v_claim_kpi_base
GROUP BY payer_name, service_year, service_month
ORDER BY payer_name, service_year, service_month;

-- Denial reasons
SELECT
    COALESCE(denial_reason, 'Unknown') AS denial_reason,
    COUNT(*) AS denied_claims,
    SUM(billed_amount) AS denied_billed_amount,
    AVG(days_in_ar)    AS avg_days_in_ar_for_denied
FROM v_claim_kpi_base
WHERE is_denied = 1
GROUP BY COALESCE(denial_reason, 'Unknown')
ORDER BY denied_billed_amount DESC;

-- A/R aging
SELECT
    CASE 
        WHEN days_in_ar <= 30 THEN '0-30'
        WHEN days_in_ar BETWEEN 31 AND 60 THEN '31-60'
        WHEN days_in_ar BETWEEN 61 AND 90 THEN '61-90'
        ELSE '>90'
    END AS ar_bucket,
    SUM(billed_amount - COALESCE(paid_amount,0) - COALESCE(adjustment_amount,0)) AS ar_amount
FROM v_claim_kpi_base
GROUP BY ar_bucket
ORDER BY 
    CASE ar_bucket
        WHEN '0-30' THEN 1
        WHEN '31-60' THEN 2
        WHEN '61-90' THEN 3
        ELSE 4
    END;
