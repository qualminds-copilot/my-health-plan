-- Diagnoses table to store diagnosis codes and descriptions
-- Run this as: psql -U postgres -d myhealthplan -f 04_diagnoses_table.sql

CREATE TABLE IF NOT EXISTS diagnoses (
    id SERIAL PRIMARY KEY,
    diagnosis_code VARCHAR(20) NOT NULL UNIQUE,
    diagnosis_description VARCHAR(255) NOT NULL,
    icd_10_code VARCHAR(20),
    category VARCHAR(100),
    severity VARCHAR(20), -- Low, Medium, High
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample diagnoses from dashboard
INSERT INTO diagnoses (diagnosis_code, diagnosis_description, icd_10_code, category, severity) VALUES
('DKA', 'Diabetic Ketoacidosis', 'E10.10', 'Endocrine', 'High'),
('CHF', 'Congestive Heart Failure', 'I50.9', 'Cardiovascular', 'High'),
('CKD', 'Chronic Kidney Disease', 'N18.9', 'Renal', 'High'),
('Cellulitis', 'Cellulitis', 'L03.90', 'Infectious', 'Medium'),
('COPD', 'Chronic Obstructive Pulmonary Disease', 'J44.1', 'Respiratory', 'Medium'),
('UTI', 'Urinary Tract Infection', 'N39.0', 'Infectious', 'Medium');

-- Create index for faster lookups
CREATE INDEX idx_diagnoses_code ON diagnoses(diagnosis_code);
CREATE INDEX idx_diagnoses_category ON diagnoses(category);
