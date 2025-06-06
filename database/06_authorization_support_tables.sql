-- Authorization history table for tracking status changes and reviews
CREATE TABLE IF NOT EXISTS authorization_history (
    id SERIAL PRIMARY KEY,
    authorization_id INTEGER NOT NULL REFERENCES authorizations(id),
    status_from VARCHAR(50),
    status_to VARCHAR(50) NOT NULL,
    changed_by INTEGER REFERENCES users(id),
    change_reason TEXT,
    notes TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Authorization documents table for storing related documents
CREATE TABLE IF NOT EXISTS authorization_documents (
    id SERIAL PRIMARY KEY,
    authorization_id INTEGER NOT NULL REFERENCES authorizations(id),
    document_type VARCHAR(100) NOT NULL, -- 'Medical Records', 'Lab Results', 'Imaging', etc.
    document_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500),
    file_size INTEGER,
    mime_type VARCHAR(100),
    uploaded_by INTEGER REFERENCES users(id),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Authorization notes table for reviewer comments
CREATE TABLE IF NOT EXISTS authorization_notes (
    id SERIAL PRIMARY KEY,
    authorization_id INTEGER NOT NULL REFERENCES authorizations(id),
    note_type VARCHAR(50) NOT NULL, -- 'Review', 'Clinical', 'Administrative'
    note_text TEXT NOT NULL,
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_private BOOLEAN DEFAULT FALSE
);

-- Create summary view for dashboard queries
CREATE OR REPLACE VIEW authorization_summary AS
SELECT 
    a.id,
    a.authorization_number,
    a.priority,
    a.status,
    a.request_type,
    a.review_type,
    a.received_date,
    a.admission_date,
    a.approved_days,
    a.next_review_date,
    a.pos,
    -- Member info
    CONCAT(m.first_name, ', ', m.last_name) as member_name,
    m.member_number,
    -- Provider info
    p.provider_name,
    p.provider_code,
    -- Diagnosis info
    d.diagnosis_code,
    d.diagnosis_name,
    -- DRG info
    drg.drg_code,
    drg.drg_description,
    -- Calculated fields
    CASE 
        WHEN a.next_review_date::date = CURRENT_DATE THEN 'Due Today'
        WHEN a.next_review_date::date < CURRENT_DATE THEN 'Overdue'
        WHEN a.next_review_date::date <= CURRENT_DATE + INTERVAL '7 days' THEN 'Due This Week'
        ELSE 'Future'
    END as review_status,
    EXTRACT(EPOCH FROM (a.next_review_date - a.received_date))/86400 as days_pending
FROM authorizations a
LEFT JOIN members m ON a.member_id = m.id
LEFT JOIN providers p ON a.provider_id = p.id
LEFT JOIN diagnoses d ON a.diagnosis_id = d.id
LEFT JOIN drg_codes drg ON a.drg_code_id = drg.id;

-- Create indexes for supporting tables
CREATE INDEX idx_auth_history_auth_id ON authorization_history(authorization_id);
CREATE INDEX idx_auth_history_changed_at ON authorization_history(changed_at);
CREATE INDEX idx_auth_documents_auth_id ON authorization_documents(authorization_id);
CREATE INDEX idx_auth_notes_auth_id ON authorization_notes(authorization_id);
CREATE INDEX idx_auth_notes_created_at ON authorization_notes(created_at);
