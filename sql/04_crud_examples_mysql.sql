USE rcm_project;

-- CREATE
INSERT INTO dim_payer (payer_id, payer_name, payer_type)
VALUES (10, 'Cynex Health Plan', 'Commercial');

INSERT INTO dim_patient (patient_id, gender, date_of_birth, city, insurance_type)
VALUES (201, 'F', '1990-04-12', 'Dhaka', 'PPO');

INSERT INTO fact_claim (
    claim_id, patient_id, payer_id,
    service_date, claim_submit_date, payment_date,
    billed_amount, paid_amount, adjustment_amount,
    claim_status, denial_reason
) VALUES (
    2001, 201, 10,
    '2025-04-01', '2025-04-02', NULL,
    1800.00, 0.00, 0.00,
    'Pending', NULL
);

-- READ
SELECT * FROM dim_patient WHERE patient_id = 201;

SELECT claim_id, patient_id, billed_amount, claim_status
FROM fact_claim
WHERE payer_id = 10
  AND claim_status IN ('Pending', 'Denied');

SELECT
    c.claim_id,
    p.payer_name,
    c.billed_amount,
    c.paid_amount,
    c.claim_status
FROM fact_claim c
JOIN dim_payer p ON c.payer_id = p.payer_id
WHERE c.patient_id = 201;

-- UPDATE
UPDATE fact_claim
SET 
    payment_date      = '2025-04-20',
    paid_amount       = 1700.00,
    adjustment_amount = 100.00,
    claim_status      = 'Paid',
    denial_reason     = NULL
WHERE claim_id = 2001;

UPDATE dim_patient
SET city = 'Gazipur'
WHERE patient_id = 201;

-- DELETE
DELETE FROM fact_claim
WHERE claim_id = 2001;

DELETE FROM dim_patient
WHERE patient_id = 201;
