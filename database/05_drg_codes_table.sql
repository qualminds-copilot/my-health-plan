-- DRG codes table to store Diagnosis Related Group information
-- Run this as: psql -U postgres -d myhealthplan -f 05_drg_codes_table.sql

CREATE TABLE IF NOT EXISTS drg_codes (
    id SERIAL PRIMARY KEY,
    drg_code VARCHAR(20) NOT NULL UNIQUE,
    drg_description VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    average_length_of_stay INTEGER,
    weight DECIMAL(5,3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample DRG codes from dashboard
INSERT INTO drg_codes (drg_code, drg_description, category, average_length_of_stay, weight) VALUES
('637', 'Diabetes with Major Complications', 'Endocrine', 5, 1.234),
('291', 'Heart Failure and Shock with MCC', 'Cardiovascular', 6, 1.456),
('687', 'Kidney and Urinary Tract Procedures', 'Renal', 4, 1.123),
('688', 'Other Kidney and Urinary Tract Procedures', 'Renal', 3, 0.987),
('638', 'Diabetes with Minor Complications', 'Endocrine', 3, 0.876),
('602', 'Cellulitis with MCC', 'Infectious', 4, 1.098),
('191', 'Chronic Obstructive Pulmonary Disease', 'Respiratory', 4, 1.045),
('690', 'Kidney and Urinary Tract Infections', 'Renal', 3, 0.789);

-- Create index for faster lookups
CREATE INDEX idx_drg_codes_code ON drg_codes(drg_code);
CREATE INDEX idx_drg_codes_category ON drg_codes(category);
