USE rcm_project;

INSERT INTO dim_payer (payer_id, payer_name, payer_type) VALUES
(1, 'Alpha Health', 'Commercial'),
(2, 'Beta Insurance', 'Commercial'),
(3, 'GovCare', 'Government');

INSERT INTO dim_patient (patient_id, gender, date_of_birth, city, insurance_type) VALUES
(101, 'F', '1985-03-15', 'Dhaka',       'HMO'),
(102, 'M', '1978-11-02', 'Chattogram',  'PPO'),
(103, 'F', '1992-07-21', 'Dhaka',       'Gov'),
(104, 'M', '1989-01-09', 'Gazipur',     'HMO'),
(105, 'F', '1995-05-30', 'Narayanganj', 'PPO');

INSERT INTO fact_claim (
    claim_id, patient_id, payer_id,
    service_date, claim_submit_date, payment_date,
    billed_amount, paid_amount, adjustment_amount,
    claim_status, denial_reason
) VALUES
(1001, 101, 1, '2025-01-05', '2025-01-06', '2025-01-25', 1000.00,  950.00,  50.00, 'Paid',   NULL),
(1002, 102, 2, '2025-01-10', '2025-01-11', '2025-02-20', 1500.00, 1200.00, 300.00, 'Paid',   NULL),
(1003, 103, 3, '2025-01-18', '2025-01-20', NULL,          800.00,    0.00,   0.00, 'Pending', NULL),
(1004, 101, 1, '2025-02-02', '2025-02-03', '2025-03-10', 2000.00,    0.00,   0.00, 'Denied', 'Eligibility'),
(1005, 102, 2, '2025-02-15', '2025-02-16', '2025-03-01',  500.00,  480.00,  20.00, 'Paid',   NULL),
(1006, 104, 1, '2025-02-20', '2025-02-22', NULL,         2200.00,    0.00,   0.00, 'Pending', NULL),
(1007, 105, 2, '2025-03-05', '2025-03-06', '2025-03-25', 1200.00, 1100.00, 100.00, 'Paid',   NULL),
(1008, 103, 3, '2025-03-10', '2025-03-11', '2025-04-30',  900.00,  700.00, 200.00, 'Paid',   NULL),
(1009, 104, 1, '2025-03-18', '2025-03-19', '2025-05-05', 3000.00,    0.00,   0.00, 'Denied', 'Coding'),
(1010, 105, 2, '2025-03-25', '2025-03-26', NULL,         1750.00,    0.00,   0.00, 'Pending', NULL);
