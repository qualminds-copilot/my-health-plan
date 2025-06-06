-- Authorizations table - main table for all authorization requests
CREATE TABLE IF NOT EXISTS authorizations (
    id SERIAL PRIMARY KEY,
    authorization_number VARCHAR(50) UNIQUE NOT NULL,
    member_id INTEGER NOT NULL REFERENCES members(id),
    provider_id INTEGER NOT NULL REFERENCES providers(id),
    diagnosis_id INTEGER REFERENCES diagnoses(id),
    drg_code_id INTEGER REFERENCES drg_codes(id),
    
    -- Request details
    request_type VARCHAR(50) NOT NULL, -- 'Inpatient', 'Outpatient', 'Emergency'
    review_type VARCHAR(50) NOT NULL, -- 'Initial Review', 'Concurrent Review', 'Retrospective Review'
    priority VARCHAR(20) NOT NULL DEFAULT 'Medium', -- 'High', 'Medium', 'Low'
    
    -- Dates
    received_date TIMESTAMP NOT NULL,
    admission_date DATE,
    requested_los INTEGER, -- Requested length of stay in days
    approved_days INTEGER DEFAULT 0,
    
    -- Review dates
    next_review_date TIMESTAMP,
    last_review_date TIMESTAMP,
    
    -- Status and workflow
    status VARCHAR(50) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Approved', 'Denied', 'In Review', 'Appeal'
    pos VARCHAR(10), -- Place of Service
    
    -- Additional fields
    medical_necessity TEXT,
    clinical_notes TEXT,
    denial_reason TEXT,
    appeal_notes TEXT,
    
    -- Audit fields
    created_by INTEGER REFERENCES users(id),
    assigned_to INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample authorizations matching the dashboard data
INSERT INTO authorizations (
    authorization_number, member_id, provider_id, diagnosis_id, drg_code_id,
    request_type, review_type, priority, received_date, admission_date,
    approved_days, next_review_date, status, pos
) VALUES
('2025OP000389', 1, 1, 1, 1, 'Inpatient', 'Initial Review', 'High', 
 '2025-04-28 03:47:01', '2025-04-28', 3, '2025-04-28 10:00:00', 'Pending', '637'),

('2025OP000387', 2, 2, 2, 2, 'Inpatient', 'Initial Review', 'High',
 '2025-04-28 04:35:02', '2025-04-28', 3, '2025-04-28 10:30:00', 'Pending', '291'),

('2025OP000928', 3, 3, 3, 3, 'Inpatient', 'Concurrent Review', 'High',
 '2025-04-28 05:02:03', '2025-04-28', 3, '2025-04-28 11:30:00', 'Pending', '687'),

('2025OP000278', 4, 4, 3, 4, 'Inpatient', 'Initial Review', 'High',
 '2025-04-28 05:47:04', '2025-04-28', 3, '2025-04-28 12:00:00', 'Pending', '688'),

('2025OP000378', 5, 5, 1, 1, 'Inpatient', 'Initial Review', 'High',
 '2025-04-28 06:14:05', '2025-04-28', 3, '2025-04-28 12:30:00', 'Pending', '637'),

('2025OP000312', 6, 6, 1, 5, 'Inpatient', 'Concurrent Review', 'High',
 '2025-04-27 17:38:06', '2025-04-27', 3, '2025-04-28 13:00:00', 'Appeal', '638'),

('2025OP000152', 7, 7, 6, 6, 'Inpatient', 'Concurrent Review', 'Medium',
 '2025-04-27 14:34:07', '2025-04-27', 3, '2025-04-28 14:00:00', 'In Review', '602'),

('2025OP000369', 8, 8, 4, 7, 'Inpatient', 'Initial Review', 'Medium',
 '2025-04-28 07:33:08', '2025-04-28', 3, '2025-04-28 14:30:00', 'Pending', '191'),

('2025OP000189', 9, 5, 5, 8, 'Inpatient', 'Concurrent Review', 'Medium',
 '2025-04-28 08:16:09', '2025-04-28', 3, '2025-04-28 15:00:00', 'Pending', '690'),

('2025OP000390', 10, 7, 1, 1, 'Inpatient', 'Initial Review', 'Medium',
 '2025-04-27 16:16:10', '2025-04-27', 3, '2025-04-28 15:30:00', 'In Review', '637');

-- Create indexes for better performance
CREATE INDEX idx_auth_number ON authorizations(authorization_number);
CREATE INDEX idx_auth_member ON authorizations(member_id);
CREATE INDEX idx_auth_provider ON authorizations(provider_id);
CREATE INDEX idx_auth_status ON authorizations(status);
CREATE INDEX idx_auth_priority ON authorizations(priority);
CREATE INDEX idx_auth_received_date ON authorizations(received_date);
CREATE INDEX idx_auth_next_review ON authorizations(next_review_date);
CREATE INDEX idx_auth_admission_date ON authorizations(admission_date);
