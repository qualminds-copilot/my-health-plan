-- Authorizations table to store prior authorization requests
-- Run this as: psql -U postgres -d myhealthplan -f 06_authorizations_table.sql

CREATE TABLE IF NOT EXISTS authorizations (
    id SERIAL PRIMARY KEY,
    authorization_number VARCHAR(50) NOT NULL UNIQUE,
    member_id INTEGER REFERENCES members(id),
    provider_id INTEGER REFERENCES providers(id),
    diagnosis_id INTEGER REFERENCES diagnoses(id),
    drg_code VARCHAR(20) REFERENCES drg_codes(drg_code),
    priority VARCHAR(20) NOT NULL CHECK (priority IN ('High', 'Medium', 'Low')),
    status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    review_type VARCHAR(50) NOT NULL, -- Initial Review, Concurrent Review, etc.
    pos VARCHAR(10), -- Place of Service
    received_date TIMESTAMP NOT NULL,
    admission_date DATE,
    approved_days INTEGER DEFAULT 0,
    next_review_date TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample authorization data from dashboard
INSERT INTO authorizations (
    authorization_number, member_id, provider_id, diagnosis_id, drg_code, 
    priority, status, review_type, pos, received_date, admission_date, 
    approved_days, next_review_date
) VALUES
('2025OP000389', 1, 1, 1, '637', 'High', 'Pending', 'Initial Review', '637', '2025-04-28 03:47:01', '2025-04-28', 3, '2025-04-28 10:00:00'),
('2025OP000387', 2, 2, 2, '291', 'High', 'Pending', 'Initial Review', '291', '2025-04-28 04:35:02', '2025-04-28', 3, '2025-04-28 10:30:00'),
('2025OP000928', 3, 3, 3, '687', 'High', 'Pending', 'Concurrent Review', '687', '2025-04-28 05:02:03', '2025-04-28', 3, '2025-04-28 11:30:00'),
('2025OP000278', 4, 4, 3, '688', 'High', 'Pending', 'Initial Review', '688', '2025-04-28 05:47:04', '2025-04-28', 3, '2025-04-28 12:00:00'),
('2025OP000378', 5, 5, 1, '637', 'High', 'Pending', 'Initial Review', '637', '2025-04-28 06:14:05', '2025-04-28', 3, '2025-04-28 12:30:00'),
('2025OP000312', 6, 6, 1, '638', 'High', 'APPEAL', 'Concurrent Review', '638', '2025-04-27 17:38:06', '2025-04-27', 3, '2025-04-28 13:00:00'),
('2025OP000152', 7, 7, 4, '602', 'Medium', 'In Review', 'Concurrent Review', '602', '2025-04-27 14:34:07', '2025-04-27', 3, '2025-04-28 14:00:00'),
('2025OP000369', 8, 8, 5, '191', 'Medium', 'Pending', 'Initial Review', '191', '2025-04-28 07:33:08', '2025-04-28', 3, '2025-04-28 14:30:00'),
('2025OP000189', 9, 5, 6, '690', 'Medium', 'Pending', 'Concurrent Review', '690', '2025-04-28 08:16:09', '2025-04-28', 3, '2025-04-28 15:00:00'),
('2025OP000390', 10, 7, 1, '637', 'Medium', 'In Review', 'Initial Review', '637', '2025-04-27 16:16:10', '2025-04-27', 3, '2025-04-28 15:30:00');

-- Create indexes for faster lookups
CREATE INDEX idx_authorizations_number ON authorizations(authorization_number);
CREATE INDEX idx_authorizations_member ON authorizations(member_id);
CREATE INDEX idx_authorizations_provider ON authorizations(provider_id);
CREATE INDEX idx_authorizations_status ON authorizations(status);
CREATE INDEX idx_authorizations_priority ON authorizations(priority);
CREATE INDEX idx_authorizations_received_date ON authorizations(received_date);
CREATE INDEX idx_authorizations_next_review ON authorizations(next_review_date);
