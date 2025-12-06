CREATE DATABASE IF NOT EXISTS rcm_project;
USE rcm_project;

CREATE TABLE dim_patient (
    patient_id      INT PRIMARY KEY,
    gender          VARCHAR(10),
    date_of_birth   DATE,
    city            VARCHAR(100),
    insurance_type  VARCHAR(50)
);

CREATE TABLE dim_payer (
    payer_id    INT PRIMARY KEY,
    payer_name  VARCHAR(100),
    payer_type  VARCHAR(50)
);

CREATE TABLE fact_claim (
    claim_id           INT PRIMARY KEY,
    patient_id         INT,
    payer_id           INT,
    service_date       DATE,
    claim_submit_date  DATE,
    payment_date       DATE,
    billed_amount      DECIMAL(12,2),
    paid_amount        DECIMAL(12,2),
    adjustment_amount  DECIMAL(12,2),
    claim_status       VARCHAR(20),
    denial_reason      VARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES dim_patient(patient_id),
    FOREIGN KEY (payer_id)   REFERENCES dim_payer(payer_id)
);
