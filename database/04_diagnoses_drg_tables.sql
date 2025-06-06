-- Diagnoses table to store diagnosis codes and descriptions
CREATE TABLE IF NOT EXISTS diagnoses (
    id SERIAL PRIMARY KEY,
    diagnosis_code VARCHAR(20) UNIQUE NOT NULL,
    diagnosis_name VARCHAR(255) NOT NULL,
    description TEXT,
    icd_10_code VARCHAR(20),
    category VARCHAR(100),
    severity VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample diagnoses from the dashboard
INSERT INTO diagnoses (diagnosis_code, diagnosis_name, description, category, severity) VALUES
('DKA', 'Diabetic Ketoacidosis', 'A serious complication of diabetes', 'Endocrine', 'High'),
('CHF', 'Congestive Heart Failure', 'Heart cannot pump blood effectively', 'Cardiovascular', 'High'),
('CKD', 'Chronic Kidney Disease', 'Long-term kidney damage', 'Renal', 'High'),
('COPD', 'Chronic Obstructive Pulmonary Disease', 'Lung disease that blocks airflow', 'Respiratory', 'Medium'),
('UTI', 'Urinary Tract Infection', 'Infection in urinary system', 'Genitourinary', 'Medium'),
('CELLULITIS', 'Cellulitis', 'Bacterial skin infection', 'Dermatologic', 'Medium');

-- DRG (Diagnosis Related Group) table
CREATE TABLE IF NOT EXISTS drg_codes (
    id SERIAL PRIMARY KEY,
    drg_code VARCHAR(10) UNIQUE NOT NULL,
    drg_description TEXT,
    category VARCHAR(100),
    weight DECIMAL(5,3),
    los_geometric_mean DECIMAL(5,2), -- Length of stay geometric mean
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample DRG codes from the dashboard
INSERT INTO drg_codes (drg_code, drg_description, category, weight, los_geometric_mean) VALUES
('637', 'Diabetes with complications', 'Endocrine', 1.245, 4.2),
('291', 'Heart failure and shock with MCC', 'Cardiovascular', 1.678, 5.8),
('687', 'Kidney and urinary tract infections with MCC', 'Renal', 1.234, 4.5),
('688', 'Kidney and urinary tract infections without MCC', 'Renal', 0.987, 3.2),
('638', 'Diabetes with complications and comorbidities', 'Endocrine', 1.345, 4.8),
('602', 'Cellulitis without MCC', 'Dermatologic', 0.876, 3.5),
('191', 'Chronic obstructive pulmonary disease with MCC', 'Respiratory', 1.456, 5.1),
('690', 'Kidney and urinary tract infections with complications', 'Renal', 1.123, 3.8);

-- Create indexes
CREATE INDEX idx_diagnoses_code ON diagnoses(diagnosis_code);
CREATE INDEX idx_drg_code ON drg_codes(drg_code);
