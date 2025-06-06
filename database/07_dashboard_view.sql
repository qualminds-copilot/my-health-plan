-- Dashboard view to simplify querying authorization data
-- Run this as: psql -U postgres -d myhealthplan -f 07_dashboard_view.sql

CREATE OR REPLACE VIEW authorization_dashboard AS
SELECT 
    a.id,
    a.authorization_number,
    a.priority,
    a.status,
    a.review_type,
    a.pos,
    a.received_date,
    a.admission_date,
    a.approved_days,
    a.next_review_date,
    a.created_at,
    a.updated_at,
    m.first_name || ' ' || m.last_name AS member_name,
    m.member_number,
    p.provider_name,
    d.diagnosis_code,
    d.diagnosis_description,
    a.drg_code,
    dr.drg_description
FROM authorizations a
LEFT JOIN members m ON a.member_id = m.id
LEFT JOIN providers p ON a.provider_id = p.id
LEFT JOIN diagnoses d ON a.diagnosis_id = d.id
LEFT JOIN drg_codes dr ON a.drg_code = dr.drg_code
ORDER BY a.priority DESC, a.received_date DESC;

-- Create a summary view for dashboard cards
CREATE OR REPLACE VIEW dashboard_summary AS
SELECT 
    COUNT(*) FILTER (WHERE DATE(next_review_date) = CURRENT_DATE) AS due_today,
    COUNT(*) FILTER (WHERE priority = 'High') AS high_priority,
    COUNT(*) FILTER (WHERE DATE(next_review_date) = CURRENT_DATE) AS reminder_today,
    COUNT(*) FILTER (WHERE DATE(received_date) >= DATE_TRUNC('week', CURRENT_DATE)) AS start_this_week,
    COUNT(*) AS total_authorizations
FROM authorizations
WHERE status IN ('Pending', 'In Review', 'APPEAL');
