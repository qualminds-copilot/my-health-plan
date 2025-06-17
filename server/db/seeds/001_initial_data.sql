-- Seed: Initial Application Data
-- Description: Load initial reference data and sample records for MyHealthPlan application

-- Seed: Initial Application Data
-- Description: Load initial reference data and sample records for MyHealthPlan application

-- Insert diagnoses (only if they don't exist)
INSERT INTO diagnoses (id, diagnosis_code, diagnosis_name, description, icd_10_code, category, severity, created_at) 
SELECT * FROM (VALUES
(1, 'DKA', 'Diabetic Ketoacidosis', 'A serious complication of diabetes', NULL, 'Endocrine', 'High', CURRENT_TIMESTAMP),
(2, 'CHF', 'Congestive Heart Failure', 'Heart cannot pump blood effectively', NULL, 'Cardiovascular', 'High', CURRENT_TIMESTAMP),
(3, 'CKD', 'Chronic Kidney Disease', 'Long-term kidney damage', NULL, 'Renal', 'High', CURRENT_TIMESTAMP),
(4, 'COPD', 'Chronic Obstructive Pulmonary Disease', 'Lung disease that blocks airflow', NULL, 'Respiratory', 'Medium', CURRENT_TIMESTAMP),
(5, 'UTI', 'Urinary Tract Infection', 'Infection in urinary system', NULL, 'Genitourinary', 'Medium', CURRENT_TIMESTAMP),
(6, 'CELLULITIS', 'Cellulitis', 'Bacterial skin infection', NULL, 'Dermatologic', 'Medium', CURRENT_TIMESTAMP)
) AS v(id, diagnosis_code, diagnosis_name, description, icd_10_code, category, severity, created_at)
WHERE NOT EXISTS (SELECT 1 FROM diagnoses WHERE diagnoses.diagnosis_code = v.diagnosis_code);

-- Insert DRG codes (only if they don't exist)
INSERT INTO drg_codes (id, drg_code, drg_description, category, weight, los_geometric_mean, created_at) 
SELECT * FROM (VALUES
(1, '637', 'Diabetes with complications', 'Endocrine', 1.245, 4.20, CURRENT_TIMESTAMP),
(2, '291', 'Heart failure and shock with MCC', 'Cardiovascular', 1.678, 5.80, CURRENT_TIMESTAMP),
(3, '687', 'Kidney and urinary tract infections with MCC', 'Renal', 1.234, 4.50, CURRENT_TIMESTAMP),
(4, '688', 'Kidney and urinary tract infections without MCC', 'Renal', 0.987, 3.20, CURRENT_TIMESTAMP),
(5, '638', 'Diabetes with complications and comorbidities', 'Endocrine', 1.345, 4.80, CURRENT_TIMESTAMP),
(6, '602', 'Cellulitis without MCC', 'Dermatologic', 0.876, 3.50, CURRENT_TIMESTAMP),
(7, '191', 'Chronic obstructive pulmonary disease with MCC', 'Respiratory', 1.456, 5.10, CURRENT_TIMESTAMP),
(8, '690', 'Kidney and urinary tract infections with complications', 'Renal', 1.123, 3.80, CURRENT_TIMESTAMP)
) AS v(id, drg_code, drg_description, category, weight, los_geometric_mean, created_at)
WHERE NOT EXISTS (SELECT 1 FROM drg_codes WHERE drg_codes.drg_code = v.drg_code);

-- Insert sample members (only if they don't exist)
INSERT INTO members (id, member_number, first_name, last_name, date_of_birth, gender, phone, email, address, insurance_group, policy_number, created_at, updated_at) 
SELECT * FROM (VALUES
(1, 'MEM001', 'Robert', 'Abbott', '1985-03-15'::date, 'M', NULL, NULL, NULL, 'Silvermine', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'MEM002', 'Samuel', 'Perry', '1978-07-22'::date, 'M', NULL, NULL, NULL, 'Evernorth', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'MEM003', 'Kate', 'Sawyer', '1992-11-08'::date, 'F', NULL, NULL, NULL, 'Cascade I', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'MEM004', 'Laura', 'Smith', '1981-05-30'::date, 'F', NULL, NULL, NULL, 'Palicade R', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'MEM005', 'Renee', 'Rutherford', '1975-09-12'::date, 'F', NULL, NULL, NULL, 'Trinity Oal', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(6, 'MEM006', 'Mike', 'Andrews', '1988-12-04'::date, 'M', NULL, NULL, NULL, 'LumenPoi', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(7, 'MEM007', 'James', 'Oliver', '1973-04-18'::date, 'M', NULL, NULL, NULL, 'St. Aureliu', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(8, 'MEM008', 'John', 'Emerson', '1990-08-25'::date, 'M', NULL, NULL, NULL, 'Cobalt Bay', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(9, 'MEM009', 'Samuel', 'Perry', '1982-01-14'::date, 'M', NULL, NULL, NULL, 'Trinity Oal', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(10, 'MEM010', 'Laura', 'Smith', '1987-06-09'::date, 'F', NULL, NULL, NULL, 'St. Aureliu', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
) AS v(id, member_number, first_name, last_name, date_of_birth, gender, phone, email, address, insurance_group, policy_number, created_at, updated_at)
WHERE NOT EXISTS (SELECT 1 FROM members WHERE members.member_number = v.member_number);

-- Insert sample providers (only if they don't exist)
INSERT INTO providers (id, provider_code, provider_name, provider_type, address, phone, fax, email, npi, tax_id, contract_status, created_at, updated_at) 
SELECT * FROM (VALUES
(1, 'SILV001', 'Silvermine Medical Center', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'EVER001', 'Evernorth Healthcare', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'CASC001', 'Cascade I Medical', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'PALI001', 'Palicade Regional', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'TRIN001', 'Trinity Oal Hospital', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(6, 'LUME001', 'LumenPoi Medical Center', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(7, 'SAUR001', 'St. Aurelius Hospital', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(8, 'COBA001', 'Cobalt Bay Medical', 'Hospital', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
) AS v(id, provider_code, provider_name, provider_type, address, phone, fax, email, npi, tax_id, contract_status, created_at, updated_at)
WHERE NOT EXISTS (SELECT 1 FROM providers WHERE providers.provider_code = v.provider_code);

-- Insert sample users (only if they don't exist) - all using the same password: 'password123'
INSERT INTO users (id, username, email, password_hash, full_name, role, created_at, updated_at) 
SELECT * FROM (VALUES
(1, 'admin', 'admin@myhealthplan.com', '$2b$10$UkbPFVCy7mrJrOjaQ4V4OeVkH7.i6/IAML2k1n9o.7efwpUScN.VW', 'System Administrator', 'admin', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'maria.hartsell', 'maria.hartsell@myhealthplan.com', '$2b$10$UkbPFVCy7mrJrOjaQ4V4OeVkH7.i6/IAML2k1n9o.7efwpUScN.VW', 'Maria Hartsell', 'admin', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'john.doe', 'john.doe@myhealthplan.com', '$2b$10$UkbPFVCy7mrJrOjaQ4V4OeVkH7.i6/IAML2k1n9o.7efwpUScN.VW', 'John Doe', 'user', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'jane.smith', 'jane.smith@myhealthplan.com', '$2b$10$UkbPFVCy7mrJrOjaQ4V4OeVkH7.i6/IAML2k1n9o.7efwpUScN.VW', 'Jane Smith', 'user', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
) AS v(id, username, email, password_hash, full_name, role, created_at, updated_at)
WHERE NOT EXISTS (SELECT 1 FROM users WHERE users.username = v.username);

-- Insert priority levels (only if they don't exist)
INSERT INTO priority_levels (id, priority_code, priority_name, description, color_code, sort_order, is_active) 
SELECT * FROM (VALUES
(1, 'HIGH', 'High', 'Urgent cases requiring immediate attention', '#dc3545', 1, true),
(2, 'MEDIUM', 'Medium', 'Standard priority cases', '#ffc107', 2, true),
(3, 'LOW', 'Low', 'Low priority cases', '#198754', 3, true)
) AS v(id, priority_code, priority_name, description, color_code, sort_order, is_active)
WHERE NOT EXISTS (SELECT 1 FROM priority_levels WHERE priority_levels.priority_code = v.priority_code);

-- Insert review types (only if they don't exist)
INSERT INTO review_types (id, review_code, review_name, description, typical_duration_hours, is_active) 
SELECT * FROM (VALUES
(1, 'INITIAL', 'Initial Review', 'First review of authorization request', 24, true),
(2, 'CONCURRENT', 'Concurrent Review', 'Ongoing review during treatment', 8, true),
(3, 'RETROSPECTIVE', 'Retrospective Review', 'Review after treatment completion', 72, true),
(4, 'APPEAL', 'Appeal Review', 'Review of appealed decision', 48, true)
) AS v(id, review_code, review_name, description, typical_duration_hours, is_active)
WHERE NOT EXISTS (SELECT 1 FROM review_types WHERE review_types.review_code = v.review_code);

-- Insert status types (only if they don't exist)
INSERT INTO status_types (id, status_code, status_name, description, color_code, is_final, sort_order, is_active) 
SELECT * FROM (VALUES
(1, 'PENDING', 'Pending', 'Awaiting review', '#ffc107', false, 1, true),
(2, 'IN_REVIEW', 'In Review', 'Currently being reviewed', '#0dcaf0', false, 2, true),
(3, 'APPROVED', 'Approved', 'Authorization approved', '#198754', true, 3, true),
(4, 'DENIED', 'Denied', 'Authorization denied', '#dc3545', true, 4, true),
(5, 'APPEAL', 'Appeal', 'Under appeal process', '#dc3545', false, 5, true),
(6, 'EXPIRED', 'Expired', 'Authorization expired', '#6c757d', true, 6, true)
) AS v(id, status_code, status_name, description, color_code, is_final, sort_order, is_active)
WHERE NOT EXISTS (SELECT 1 FROM status_types WHERE status_types.status_code = v.status_code);

-- Insert sample authorizations (only if we don't have any existing data)
INSERT INTO authorizations (id, authorization_number, member_id, provider_id, diagnosis_id, drg_code_id, request_type, review_type, priority, received_date, admission_date, requested_los, approved_days, next_review_date, last_review_date, status, pos, medical_necessity, clinical_notes, denial_reason, appeal_notes, created_by, assigned_to, created_at, updated_at) 
SELECT * FROM (VALUES
(1, '2025OP000389', 1, 1, 1, 1, 'Inpatient', 'Initial Review', 'High', '2025-06-16 01:15:00'::timestamp, '2025-06-15'::date, 3, 3, '2025-06-16 01:15:00'::timestamp, NULL::timestamp, 'Pending', '637', NULL, NULL, NULL, NULL, NULL::integer, NULL::integer, '2025-06-15 00:00:00'::timestamp, CURRENT_TIMESTAMP),
(2, '2025OP000387', 2, 2, 2, 2, 'Inpatient', 'Initial Review', 'High', '2025-06-16 02:30:00'::timestamp, '2025-06-16'::date, 4, 3, '2025-06-16 02:30:00'::timestamp, NULL::timestamp, 'Pending', '291', NULL, NULL, NULL, NULL, NULL::integer, NULL::integer, '2025-06-14 00:00:00'::timestamp, CURRENT_TIMESTAMP),
(3, '2025OP000928', 3, 3, 3, 3, 'Inpatient', 'Concurrent Review', 'High', '2025-06-16 03:45:00'::timestamp, '2025-06-15'::date, 5, 3, '2025-06-16 03:45:00'::timestamp, NULL::timestamp, 'Pending', '687', NULL, NULL, NULL, NULL, NULL::integer, NULL::integer, '2025-06-13 00:00:00'::timestamp, CURRENT_TIMESTAMP),
(4, '2025OP000278', 4, 4, 3, 4, 'Inpatient', 'Initial Review', 'High', '2025-06-16 04:00:00'::timestamp, '2025-06-16'::date, 3, 3, '2025-06-16 04:00:00'::timestamp, NULL::timestamp, 'Pending', '688', NULL, NULL, NULL, NULL, NULL::integer, NULL::integer, '2025-06-12 00:00:00'::timestamp, CURRENT_TIMESTAMP),
(5, '2025OP000378', 5, 5, 1, 1, 'Inpatient', 'Initial Review', 'High', '2025-06-16 05:15:00'::timestamp, '2025-06-15'::date, 4, 3, '2025-06-16 05:15:00'::timestamp, NULL::timestamp, 'Pending', '637', NULL, NULL, NULL, NULL, NULL::integer, NULL::integer, '2025-06-11 00:00:00'::timestamp, CURRENT_TIMESTAMP),
(6, '2025OP000312', 6, 6, 1, 5, 'Inpatient', 'Concurrent Review', 'High', '2025-06-16 06:30:00'::timestamp, '2025-06-16'::date, 5, 3, '2025-06-16 06:30:00'::timestamp, NULL::timestamp, 'Appeal', '638', NULL, NULL, NULL, NULL, NULL::integer, NULL::integer, '2025-06-10 00:00:00'::timestamp, CURRENT_TIMESTAMP),
(7, '2025OP000152', 7, 7, 6, 6, 'Inpatient', 'Concurrent Review', 'Medium', '2025-06-16 07:45:00'::timestamp, '2025-06-15'::date, 3, 3, '2025-06-16 07:45:00'::timestamp, NULL::timestamp, 'In Review', '602', NULL, NULL, NULL, NULL, NULL::integer, NULL::integer, '2025-06-16 00:00:00'::timestamp, CURRENT_TIMESTAMP),
(8, '2025OP000369', 8, 8, 4, 7, 'Inpatient', 'Initial Review', 'Medium', '2025-06-16 08:00:00'::timestamp, '2025-06-16'::date, 4, 3, '2025-06-16 08:00:00'::timestamp, NULL::timestamp, 'Pending', '191', NULL, NULL, NULL, NULL, NULL::integer, NULL::integer, '2025-06-15 00:00:00'::timestamp, CURRENT_TIMESTAMP),
(9, '2025OP000189', 9, 5, 5, 8, 'Inpatient', 'Concurrent Review', 'Medium', '2025-06-16 09:15:00'::timestamp, '2025-06-15'::date, 3, 3, '2025-06-17 09:00:00'::timestamp, NULL::timestamp, 'Pending', '690', NULL, NULL, NULL, NULL, NULL::integer, NULL::integer, '2025-06-14 00:00:00'::timestamp, CURRENT_TIMESTAMP),
(10, '2025OP000390', 10, 7, 1, 1, 'Inpatient', 'Initial Review', 'Medium', '2025-06-16 10:30:00'::timestamp, '2025-06-16'::date, 4, 3, '2025-06-18 10:00:00'::timestamp, NULL::timestamp, 'In Review', '637', NULL, NULL, NULL, NULL, NULL::integer, NULL::integer, '2025-06-13 00:00:00'::timestamp, CURRENT_TIMESTAMP)
) AS v(id, authorization_number, member_id, provider_id, diagnosis_id, drg_code_id, request_type, review_type, priority, received_date, admission_date, requested_los, approved_days, next_review_date, last_review_date, status, pos, medical_necessity, clinical_notes, denial_reason, appeal_notes, created_by, assigned_to, created_at, updated_at)
WHERE NOT EXISTS (SELECT 1 FROM authorizations WHERE authorizations.authorization_number = v.authorization_number);

-- Reset sequences only if records were actually inserted
DO $$
DECLARE
    max_diagnoses_id INTEGER;
    max_drg_codes_id INTEGER;
    max_members_id INTEGER;
    max_providers_id INTEGER;
    max_users_id INTEGER;
    max_priority_levels_id INTEGER;
    max_review_types_id INTEGER;
    max_status_types_id INTEGER;
    max_authorizations_id INTEGER;
    records_seeded INTEGER := 0;
BEGIN
    -- Get current max IDs and update sequences accordingly
    SELECT COALESCE(MAX(id), 0) INTO max_diagnoses_id FROM diagnoses;
    SELECT COALESCE(MAX(id), 0) INTO max_drg_codes_id FROM drg_codes;
    SELECT COALESCE(MAX(id), 0) INTO max_members_id FROM members;
    SELECT COALESCE(MAX(id), 0) INTO max_providers_id FROM providers;
    SELECT COALESCE(MAX(id), 0) INTO max_users_id FROM users;
    SELECT COALESCE(MAX(id), 0) INTO max_priority_levels_id FROM priority_levels;
    SELECT COALESCE(MAX(id), 0) INTO max_review_types_id FROM review_types;
    SELECT COALESCE(MAX(id), 0) INTO max_status_types_id FROM status_types;
    SELECT COALESCE(MAX(id), 0) INTO max_authorizations_id FROM authorizations;
    
    -- Update sequences
    IF max_diagnoses_id > 0 THEN
        PERFORM setval('diagnoses_id_seq', max_diagnoses_id, true);
    END IF;
    IF max_drg_codes_id > 0 THEN
        PERFORM setval('drg_codes_id_seq', max_drg_codes_id, true);
    END IF;
    IF max_members_id > 0 THEN
        PERFORM setval('members_id_seq', max_members_id, true);
    END IF;
    IF max_providers_id > 0 THEN
        PERFORM setval('providers_id_seq', max_providers_id, true);
    END IF;
    IF max_users_id > 0 THEN
        PERFORM setval('users_id_seq', max_users_id, true);
    END IF;
    IF max_priority_levels_id > 0 THEN
        PERFORM setval('priority_levels_id_seq', max_priority_levels_id, true);
    END IF;
    IF max_review_types_id > 0 THEN
        PERFORM setval('review_types_id_seq', max_review_types_id, true);
    END IF;
    IF max_status_types_id > 0 THEN
        PERFORM setval('status_types_id_seq', max_status_types_id, true);
    END IF;
    IF max_authorizations_id > 0 THEN
        PERFORM setval('authorizations_id_seq', max_authorizations_id, true);
    END IF;
    
    -- Count total records for logging
    SELECT 
        max_diagnoses_id + max_drg_codes_id + max_members_id + max_providers_id + 
        max_users_id + max_priority_levels_id + max_review_types_id + max_status_types_id
    INTO records_seeded;
    
    RAISE NOTICE 'Seed data processing completed. Total records in reference tables: %', records_seeded;
    RAISE NOTICE 'Database: %, Seeding completed at: %', current_database(), CURRENT_TIMESTAMP;
END $$;

-- Initialize dashboard stats for current date
SELECT update_dashboard_stats();
