-- Dashboard statistics and lookup tables
CREATE TABLE IF NOT EXISTS dashboard_stats (
    id SERIAL PRIMARY KEY,
    stat_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_today_count INTEGER DEFAULT 0,
    high_priority_count INTEGER DEFAULT 0,
    reminders_count INTEGER DEFAULT 0,
    start_this_week_count INTEGER DEFAULT 0,
    total_pending_count INTEGER DEFAULT 0,
    total_in_review_count INTEGER DEFAULT 0,
    total_approved_count INTEGER DEFAULT 0,
    total_denied_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Priority levels lookup table
CREATE TABLE IF NOT EXISTS priority_levels (
    id SERIAL PRIMARY KEY,
    priority_code VARCHAR(20) UNIQUE NOT NULL,
    priority_name VARCHAR(50) NOT NULL,
    description TEXT,
    color_code VARCHAR(10), -- Hex color code
    sort_order INTEGER,
    is_active BOOLEAN DEFAULT TRUE
);

INSERT INTO priority_levels (priority_code, priority_name, description, color_code, sort_order) VALUES
('HIGH', 'High', 'Urgent cases requiring immediate attention', '#dc3545', 1),
('MEDIUM', 'Medium', 'Standard priority cases', '#ffc107', 2),
('LOW', 'Low', 'Low priority cases', '#198754', 3);

-- Status types lookup table
CREATE TABLE IF NOT EXISTS status_types (
    id SERIAL PRIMARY KEY,
    status_code VARCHAR(50) UNIQUE NOT NULL,
    status_name VARCHAR(100) NOT NULL,
    description TEXT,
    color_code VARCHAR(10),
    is_final BOOLEAN DEFAULT FALSE, -- True for final statuses like Approved/Denied
    sort_order INTEGER,
    is_active BOOLEAN DEFAULT TRUE
);

INSERT INTO status_types (status_code, status_name, description, color_code, is_final, sort_order) VALUES
('PENDING', 'Pending', 'Awaiting review', '#ffc107', FALSE, 1),
('IN_REVIEW', 'In Review', 'Currently being reviewed', '#0dcaf0', FALSE, 2),
('APPROVED', 'Approved', 'Authorization approved', '#198754', TRUE, 3),
('DENIED', 'Denied', 'Authorization denied', '#dc3545', TRUE, 4),
('APPEAL', 'Appeal', 'Under appeal process', '#dc3545', FALSE, 5),
('EXPIRED', 'Expired', 'Authorization expired', '#6c757d', TRUE, 6);

-- Review types lookup table
CREATE TABLE IF NOT EXISTS review_types (
    id SERIAL PRIMARY KEY,
    review_code VARCHAR(50) UNIQUE NOT NULL,
    review_name VARCHAR(100) NOT NULL,
    description TEXT,
    typical_duration_hours INTEGER, -- Typical time to complete review
    is_active BOOLEAN DEFAULT TRUE
);

INSERT INTO review_types (review_code, review_name, description, typical_duration_hours) VALUES
('INITIAL', 'Initial Review', 'First review of authorization request', 24),
('CONCURRENT', 'Concurrent Review', 'Ongoing review during treatment', 8),
('RETROSPECTIVE', 'Retrospective Review', 'Review after treatment completion', 72),
('APPEAL', 'Appeal Review', 'Review of appealed decision', 48);

-- Function to update dashboard statistics
CREATE OR REPLACE FUNCTION update_dashboard_stats()
RETURNS VOID AS $$
BEGIN
    INSERT INTO dashboard_stats (
        stat_date,
        due_today_count,
        high_priority_count,
        reminders_count,
        start_this_week_count,
        total_pending_count,
        total_in_review_count,
        total_approved_count,
        total_denied_count
    )
    SELECT 
        CURRENT_DATE,
        COUNT(*) FILTER (WHERE next_review_date::date = CURRENT_DATE),
        COUNT(*) FILTER (WHERE priority = 'High'),
        COUNT(*) FILTER (WHERE next_review_date::date = CURRENT_DATE),
        COUNT(*) FILTER (WHERE admission_date >= date_trunc('week', CURRENT_DATE) 
                          AND admission_date < date_trunc('week', CURRENT_DATE) + INTERVAL '1 week'),
        COUNT(*) FILTER (WHERE status = 'Pending'),
        COUNT(*) FILTER (WHERE status = 'In Review'),
        COUNT(*) FILTER (WHERE status = 'Approved'),
        COUNT(*) FILTER (WHERE status = 'Denied')
    FROM authorizations
    WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
    ON CONFLICT (stat_date) DO UPDATE SET
        due_today_count = EXCLUDED.due_today_count,
        high_priority_count = EXCLUDED.high_priority_count,
        reminders_count = EXCLUDED.reminders_count,
        start_this_week_count = EXCLUDED.start_this_week_count,
        total_pending_count = EXCLUDED.total_pending_count,
        total_in_review_count = EXCLUDED.total_in_review_count,
        total_approved_count = EXCLUDED.total_approved_count,
        total_denied_count = EXCLUDED.total_denied_count;
END;
$$ LANGUAGE plpgsql;

-- Create unique constraint on stat_date
ALTER TABLE dashboard_stats ADD CONSTRAINT unique_stat_date UNIQUE (stat_date);

-- Create indexes
CREATE INDEX idx_dashboard_stats_date ON dashboard_stats(stat_date);
CREATE INDEX idx_priority_levels_code ON priority_levels(priority_code);
CREATE INDEX idx_status_types_code ON status_types(status_code);
CREATE INDEX idx_review_types_code ON review_types(review_code);
